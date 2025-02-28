# Keycloak Image
For more information, see the [Running Keycloak in a container guide](https://www.keycloak.org/server/containers).

## Build the image

It is possible to download the Keycloak distribution from a URL:

    docker build --build-arg KEYCLOAK_DIST=http://<HOST>:<PORT>/keycloak-<VERSION>.tar.gz -t <YOUR_TAG> .

Alternatively, you need to build the local distribution first, then copy the distributions tar package in the `container` folder and point the build command to use the image:

    # First ensure you've built the project from the root directory:
    mvn clean install -DskipTests

    # Then from the quarkus/container directory:
    cp ../dist/target/keycloak-*.tar.gz .
    docker build --build-arg KEYCLOAK_DIST=keycloak-*.tar.gz -t <YOUR_TAG> .

Note: Make sure you are in the `quarkus/container` directory when running these commands. The tar.gz file will be available in the `quarkus/dist/target/` directory after building the project. The wildcard (*) in the filename will match the version number automatically.
