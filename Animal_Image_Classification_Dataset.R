library(keras3)

# Cargar imágenes desde carpetas etiquetadas
tercer_dataset <- image_dataset_from_directory(
  directory = "Animal_Image_Classification_Dataset/Animals/",
  labels = "inferred",
  label_mode = "categorical",
  image_size = c(256, 256),
  batch_size = 32
)

library(tfdatasets)

# Extraer nombres de clase
tercer_class_names <- tercer_dataset$class_names

# Convertir a vector de índices de clase
tercer_df <- as_iterator(tercer_dataset) %>%
  iterate(function(batch) {
    labels <- batch[[2]]
    apply(labels, 1, function(row) which.max(row))
  }) %>%
  unlist()

# Tabla de frecuencia
tercer_conteo <- table(factor(tercer_df, levels = seq_along(tercer_class_names), labels = tercer_class_names))

library(ggplot2)

tercer_df_plot <- data.frame(Clase = names(tercer_conteo), Cantidad = as.numeric(tercer_conteo))

ggplot(tercer_df_plot, aes(x = Clase, y = Cantidad)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Distribución de imágenes por clase", x = "Clase", y = "Cantidad")
