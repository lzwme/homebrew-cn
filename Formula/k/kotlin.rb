class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https:kotlinlang.org"
  url "https:github.comJetBrainskotlinreleasesdownloadv2.1.20kotlin-compiler-2.1.20.zip"
  sha256 "a118197b0de55ffab2bc8d5cd03a5e39033cfb53383d6931bc761dec0784891a"
  license "Apache-2.0"

  # Upstream maintains multiple majorminor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0a17cc4fea3ab754df942bc1d7630dd494b05bd538f20097c9a960b58ed8d0e"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin", "build.txt", "lib"
    rm Dir[libexec"bin*.bat"]
    bin.install Dir[libexec"bin*"]
    bin.env_script_all_files libexec"bin", Language::Java.overridable_java_home_env
    prefix.install "license"
  end

  test do
    (testpath"test.kt").write <<~KOTLIN
      fun main(args: Array<String>) {
        println("Hello World!")
      }
    KOTLIN

    system bin"kotlinc", "test.kt", "-include-runtime", "-d", "test.jar"
    system bin"kotlinc-jvm", "test.kt", "-include-runtime", "-d", "test.jar"
  end
end