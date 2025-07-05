class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https://kotlinlang.org/"
  url "https://ghfast.top/https://github.com/JetBrains/kotlin/releases/download/v2.2.0/kotlin-compiler-2.2.0.zip"
  sha256 "1adb6f1a5845ba0aa5a59e412e44c8e405236b957de1a9683619f1dca3b16932"
  license "Apache-2.0"

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ecabf4a21cd7e6e014262f2462b8fb5f4c49d602427082f327df2ea1ae525f0"
  end

  depends_on "openjdk"

  conflicts_with cask: "kotlin-native"

  def install
    libexec.install "bin", "build.txt", "lib"
    rm Dir[libexec/"bin/*.bat"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
    prefix.install "license"
  end

  test do
    (testpath/"test.kt").write <<~KOTLIN
      fun main(args: Array<String>) {
        println("Hello World!")
      }
    KOTLIN

    system bin/"kotlinc", "test.kt", "-include-runtime", "-d", "test.jar"
    system bin/"kotlinc-jvm", "test.kt", "-include-runtime", "-d", "test.jar"
  end
end