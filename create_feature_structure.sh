#!/bin/bash

# Check if a feature name and target directory are provided as arguments
if [ $# -ne 2 ]; then
  echo "Usage: $0 <feature_name> <target_directory>"
  exit 1
fi

feature_name="$1"
target_directory="$2"

# Check if the target directory exists
if [ ! -d "$target_directory" ]; then
  echo "Error: Target directory '$target_directory' does not exist."
  exit 1
fi

# Create the feature folder inside the target directory
feature_dir="$target_directory/$feature_name"
mkdir -p "$feature_dir"
echo "Created folder: $feature_dir"

# Create domain, data, and presentation folders
mkdir "$feature_dir/domain"
echo "Created folder: $feature_dir/domain"

mkdir "$feature_dir/data"
echo "Created folder: $feature_dir/data"

mkdir "$feature_dir/presentation"
echo "Created folder: $feature_dir/presentation"

# Create the 'usecases' folder within the 'domain' folder
mkdir "$feature_dir/domain/usecases"
echo "Created folder: $feature_dir/domain/usecases"

# Create basic files within the feature structure
touch "$feature_dir/data/repository.dart"
echo "Created file: $feature_dir/data/repository.dart"

touch "$feature_dir/domain/entities.dart"
echo "Created file: $feature_dir/domain/entities.dart"

# Create a use case file within the 'usecases' folder
touch "$feature_dir/domain/usecases/get_${feature_name}_data_usecase.dart"
echo "Created file: $feature_dir/domain/usecases/get_${feature_name}_data_usecase.dart"

touch "$feature_dir/presentation/widgets.dart"
echo "Created file: $feature_dir/presentation/widgets.dart"

touch "$feature_dir/presentation/controllers.dart"
echo "Created file: $feature_dir/presentation/controllers.dart"

echo "Feature structure for '$feature_name' created successfully in '$target_directory'."
