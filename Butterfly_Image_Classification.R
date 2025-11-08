library(keras3)

segundo_train_dataset <- image_dataset_from_directory(
  directory = "Butterfly_Image_Classification/train/",
  labels = NULL,
  image_size = c(224, 224),
  batch_size = 32
)

segundo_test_dataset <- image_dataset_from_directory(
  directory = "Butterfly_Image_Classification/test",
  labels = NULL,
  image_size = c(224, 224),
  batch_size = 32
)

library(readr)

# Leer CSV con columnas: filename,label
segundo_df_train <- read_csv("Butterfly_Image_Classification/Training_set.csv")
head(segundo_df_train)
segundo_df_test <- read_csv("Butterfly_Image_Classification/Testing_set.csv")
head(segundo_df_test)

# Verificar que los archivos existen
segundo_df_train$filepath <- file.path("Butterfly_Image_Classification/train", segundo_df_train$filename)
segundo_df_train <- segundo_df_train[file.exists(segundo_df_train$filepath), ]
segundo_df_test$filepath <- file.path("Butterfly_Image_Classification/test", segundo_df_test$filename)
segundo_df_test <- segundo_df_test[file.exists(segundo_df_test$filepath), ]

# Convertir etiquetas a factor
segundo_df_train$label <- factor(segundo_df_train$label)

library(ggplot2)

ggplot(segundo_df_train, aes(x = label)) +
  geom_bar(fill = "steelblue") +
  theme_minimal() +
  labs(title = "Distribución de imágenes por clase", x = "Clase", y = "Cantidad") +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 6),
    plot.title = element_text(size = 14, face = "bold")
  )
