# Instalar el paquete keras desde CRAN
#install.packages("keras3")
#install.packages("reticulate")


# Cargar la librería
library(keras3)
library(reticulate)


# Instalar TensorFlow y Keras en el entorno Python
#install_keras()
#install_tensorflow()

# Cargar imágenes desde carpetas etiquetadas
primer_train_dataset <- image_dataset_from_directory(
  directory = "Intel_Image_Classification/seg_train/seg_train/",
  labels = "inferred",              # Detecta nombres de carpetas como etiquetas
  label_mode = "categorical",       # Para clasificación multiclase
  image_size = c(150, 150),
  batch_size = 32
)

primer_test_dataset <- image_dataset_from_directory(
  directory = "Intel_Image_Classification/seg_test/seg_test/",
  labels = "inferred",
  label_mode = "categorical",
  image_size = c(150, 150),
  batch_size = 32
)

summary(primer_train_dataset)
summary(primer_test_dataset)

# Extraer nombres de clases
primer_class_names <- primer_train_dataset$class_names
print(primer_class_names)

# Contar ejemplos por clase
#install.packages("tfdatasets")
l3ibrary(tfdatasets)

# Convertir a dataframe para inspección
primer_df_train <- as_iterator(primer_train_dataset) %>%
  iterate(function(batch) {
    labels <- batch[[2]]
    apply(labels, 1, function(row) which.max(row))  # índice de clase
  }) %>%
  unlist()

primer_df_test <- as_iterator(primer_test_dataset) %>%
  iterate(function(batch) {
    labels <- batch[[2]]
    apply(labels, 1, function(row) which.max(row))
  }) %>%
  unlist()

# Tabla de frecuencia
primer_conteo_train <- table(factor(primer_df_train, levels = seq_along(primer_class_names), labels = primer_class_names))
primer_conteo_test  <- table(factor(primer_df_test, levels = seq_along(primer_class_names), labels = primer_class_names))
primer_conteo_train
primer_conteo_test


# Crear dataframe con conteo
primer_df_comparativo <- data.frame(
  Clase = rep(names(primer_conteo_train), 2),
  Cantidad = c(as.numeric(primer_conteo_train), as.numeric(primer_conteo_test)),
  Conjunto = rep(c("Entrenamiento", "Prueba"), each = length(primer_conteo_train))
)

#install.packages("ggplot2")
library(ggplot2)

ggplot(primer_df_comparativo, aes(x = Clase, y = Cantidad, fill = Conjunto)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "Comparación de imágenes por clase", x = "Clase", y = "Cantidad") +
  scale_fill_manual(values = c("steelblue", "orange"))

