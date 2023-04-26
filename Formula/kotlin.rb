class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https://kotlinlang.org/"
  url "https://ghproxy.com/https://github.com/JetBrains/kotlin/releases/download/v1.8.21/kotlin-compiler-1.8.21.zip"
  sha256 "6e43c5569ad067492d04d92c28cdf8095673699d81ce460bd7270443297e8fd7"
  license "Apache-2.0"

  # This repository has thousands of development tags, so the `GithubLatest`
  # strategy is used to minimize data transfer in this extreme case.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "878b0cd79075b77fe93eb2580aaf4d1b1b884260a24bc38036477dcf18e09612"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin", "build.txt", "lib"
    rm Dir[libexec/"bin/*.bat"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
    prefix.install "license"
  end

  test do
    (testpath/"test.kt").write <<~EOS
      fun main(args: Array<String>) {
        println("Hello World!")
      }
    EOS
    system bin/"kotlinc", "test.kt", "-include-runtime", "-d", "test.jar"
    system bin/"kotlinc-jvm", "test.kt", "-include-runtime", "-d", "test.jar"
  end
end