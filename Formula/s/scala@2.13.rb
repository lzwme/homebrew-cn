class ScalaAT213 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.13.14/scala-2.13.14.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.13.14.tgz"
  mirror "https://downloads.typesafe.com/scala/2.13.14/scala-2.13.14.tgz"
  sha256 "5af0637545f674686697f1ac7c9046bda6db638b07e23d6cf8932fc56bdb84c1"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/files/archive/"
    regex(/href=.*?scala[._-]v?(2\.13(?:\.\d+)+)(?:[._-]final)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "80de117b46f247676ede207845cbb45859b70409df95349a2b7e329d9e6c95f4"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    # Replace `/usr/local` references for uniform bottles
    inreplace Dir["man/man1/scala{,c}.1"], "/usr/local", HOMEBREW_PREFIX
    rm Dir["bin/*.bat"]
    doc.install (buildpath/"doc").children
    share.install "man"
    libexec.install "lib"
    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"lib"
    idea.install_symlink doc => "doc"
  end

  def caveats
    <<~EOS
      To use with IntelliJ, set the Scala home to:
        #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~EOS
      object Test {
        def main(args: Array[String]): Unit = {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}/scala #{file}").strip

    assert_equal "4", out
  end
end