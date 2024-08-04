class Sbuild < Formula
  desc "Scala-based build system"
  homepage "http:sbuild.org"
  url "http:sbuild.orguploadssbuild0.7.7sbuild-0.7.7-dist.zip"
  mirror "https:github.comSBuild-orgSBuild-org.github.iorawmasteruploadssbuild0.7.7sbuild-0.7.7-dist.zip"
  sha256 "606bc09603707f31d9ca5bc306ba01b171f8400e643261acd28da7a1a24dfb23"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :homepage
    regex(href=.*?sbuild[._-]v?(\d+(?:\.\d+)+)(?:[._-]dist)?\.zipi)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "0a8af36def5cab55a8a4ed2a793572ec0f0f9f5afe15681f3b6bef38d571a389"
  end

  depends_on "openjdk"

  def install
    # Delete unsupported VM option 'MaxPermSize', which is unrecognized in Java 17
    # Remove this line once upstream removes it from binsbuild
    inreplace "binsbuild", -XX:MaxPermSize=[^ ]*, ""

    libexec.install Dir["*"]
    chmod 0755, libexec"binsbuild"
    (bin"sbuild").write_env_script libexec"binsbuild", Language::Java.overridable_java_home_env
  end

  test do
    expected = <<~EOS
      import de.tototec.sbuild._

      @version("#{version}")
      class SBuild(implicit _project: Project) {

        Target("phony:clean") exec {
          Path("target").deleteRecursive
        }

        Target("phony:hello") help "Greet me" exec {
          println("Hello you")
        }

      }
    EOS
    system bin"sbuild", "--create-stub"
    assert_equal expected, (testpath"SBuild.scala").read
  end
end