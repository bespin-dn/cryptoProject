FROM openjdk:22-jdk

# 디렉터리 변경
WORKDIR /app

# Build 아티팩트 복사
COPY ./demo/build/libs/demo-0.0.1-SNAPSHOT.jar /app

# Run Application
CMD ["java", "-jar", "demo-0.0.1-SNAPSHOT.jar"]

# # git Clone
# RUN git clone https://github.com/bespin-dn/cryptoProject.git
# RUN cd cryptoProject/demo

# # Build Gradle
# RUN chmod 500 gradlew
# RUN ./gradlew build

# # Run Application
# CMD [ "executable" ]

