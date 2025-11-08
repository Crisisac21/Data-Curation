# Cargar librerías necesarias
#install.packages("ggplot2")
#install.packages("dplyr")
#install.packages("tidyr")
library(ggplot2)
library(dplyr)
library(tidyr)

# Datos globales de los tres datasets
dataset_info <- data.frame(
  Dataset = c("Intel", "Butterfly", "Animal"),
  Total_Imagenes = c(length(primer_df_train) + length(primer_df_test),
                     nrow(segundo_df_train) + nrow(segundo_df_test),
                     length(tercer_df)),
  Clases = c(length(primer_class_names),
             length(levels(segundo_df_train$label)),
             length(tercer_class_names)),
  Tiene_Train_Test = c(TRUE, TRUE, FALSE),
  Resolucion = c("150x150", "224x224", "256x256")
)

# 1. Gráfico de barras: Total de imágenes
ggplot(dataset_info, aes(x = Dataset, y = Total_Imagenes, fill = Dataset)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Cantidad total de imágenes por dataset", x = "Dataset", y = "Total de imágenes") +
  scale_fill_manual(values = c("steelblue", "orange", "forestgreen"))

# 2. Gráfico de barras: Número de clases
ggplot(dataset_info, aes(x = Dataset, y = Clases, fill = Dataset)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Número de clases por dataset", x = "Dataset", y = "Cantidad de clases") +
  scale_fill_manual(values = c("steelblue", "orange", "forestgreen"))

# Preparar datos
div_data <- dataset_info %>%
  count(Tiene_Train_Test) %>%
  mutate(
    label = ifelse(Tiene_Train_Test, "Con división", "Sin división"),
    porcentaje = round(n / sum(n) * 100, 1),
    etiqueta = paste0(label, "\n", porcentaje, "%")
  )

# Gráfico de pastel estilizado
ggplot(div_data, aes(x = "", y = n, fill = label)) +
  geom_bar(stat = "identity", width = 1, color = "white", size = 1.2) +
  coord_polar("y", start = 0) +
  theme_void() +
  labs(title = "Distribución de datasets con división train/test") +
  geom_text(aes(label = etiqueta), position = position_stack(vjust = 0.5), size = 4.5, color = "white") +
  scale_fill_manual(values = c("darkorange", "steelblue")) +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    legend.position = "none"
  )


# Convertir resolución a área en píxeles
dataset_info$Resolucion_px <- sapply(dataset_info$Resolucion, function(res) {
  dims <- as.numeric(strsplit(res, "x")[[1]])
  prod(dims)
})

# Crear gráfico
ggplot(dataset_info, aes(x = Dataset, y = Resolucion_px, fill = Dataset)) +
  geom_bar(stat = "identity", width = 0.6) +
  geom_text(aes(label = Resolucion), vjust = -0.5, size = 4) +
  theme_minimal() +
  labs(
    title = "Resolución total por dataset",
    x = "Dataset",
    y = "Resolución (px²)"
  ) +
  scale_fill_manual(values = c("steelblue", "orange", "forestgreen")) +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.text.x = element_text(size = 10)
  )


