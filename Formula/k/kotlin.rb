class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https:kotlinlang.org"
  url "https:github.comJetBrainskotlinreleasesdownloadv2.0.20kotlin-compiler-2.0.20.zip"
  sha256 "5f5d2a8ad6a718a002acd0775b67a9e27035872fdbd4b0791e3cb3ea00095931"
  license "Apache-2.0"

  # Upstream maintains multiple majorminor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "20fc8fd68c8f1237bb3d3b13c1f820b0614275384958e36fca3f2b7a7e965e96"
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