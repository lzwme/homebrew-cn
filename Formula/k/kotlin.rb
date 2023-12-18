class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https:kotlinlang.org"
  url "https:github.comJetBrainskotlinreleasesdownloadv1.9.21kotlin-compiler-1.9.21.zip"
  sha256 "cf17e0272bc065d49e64a86953b73af06065370629f090d5b7c2fe353ccf9c1a"
  license "Apache-2.0"

  # This repository has thousands of development tags, so the `GithubLatest`
  # strategy is used to minimize data transfer in this extreme case.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed81532fcac4acdbb3a232f0cc6260b4e357c0a11e17a97ba2d91105192700df"
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
    (testpath"test.kt").write <<~EOS
      fun main(args: Array<String>) {
        println("Hello World!")
      }
    EOS
    system bin"kotlinc", "test.kt", "-include-runtime", "-d", "test.jar"
    system bin"kotlinc-jvm", "test.kt", "-include-runtime", "-d", "test.jar"
  end
end