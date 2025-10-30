class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-9.2.0-all.zip"
  sha256 "16f2b95838c1ddcf7242b1c39e7bbbb43c842f1f1a1a0dc4959b6d4d68abcac3"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41a3dfeca469b7c6f97f749f189d4aec7e9bba58a3c1cd8c1ca57c81cc8ce0c9"
  end

  # https://github.com/gradle/gradle/blob/master/platforms/documentation/docs/src/docs/userguide/releases/compatibility.adoc
  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env
    (bin/"gradle").write_env_script libexec/"bin/gradle", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")

    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write <<~GRADLE
      println "gradle works!"
    GRADLE
    gradle_output = shell_output("#{bin}/gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end