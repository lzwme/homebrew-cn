class Jolie < Formula
  desc "Service-oriented programming language"
  homepage "https:www.jolie-lang.org"
  url "https:github.comjoliejoliereleasesdownloadv1.12.4jolie-1.12.4.jar"
  sha256 "572cf8664f358d5afb7fe7cafb68bd041ea5f0d7ffde06c5827dbb911f129276"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2e3c78738e3d96e94d2042a5d8ce95d7d6f0dd145a1593335fe6e4ca01e26ec"
  end

  depends_on "openjdk"

  def install
    system Formula["openjdk"].opt_bin"java",
    "-jar", "jolie-#{version}.jar",
    "--jolie-home", libexec,
    "--jolie-launchers", libexec"bin"
    bin.install Dir["#{libexec}bin*"]
    bin.env_script_all_files libexec"bin",
      JOLIE_HOME: "${JOLIE_HOME:-#{libexec}}",
      JAVA_HOME:  "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    file = testpath"test.ol"
    file.write <<~EOS
      from console import Console, ConsoleIface

      interface PowTwoInterface { OneWay: powTwo( int ) }

      service main(){

        outputPort Console { interfaces: ConsoleIface }
        embed Console in Console

        inputPort In {
          location: "local:testPort"
          interfaces: PowTwoInterface
        }

        outputPort Self {
          location: "local:testPort"
          interfaces: PowTwoInterface
        }

        init {
          powTwo@Self( 4 )
        }

        main {
          powTwo( x )
          println@Console( x * x )()
        }

      }
    EOS

    out = shell_output("#{bin}jolie #{file}").strip

    assert_equal "16", out
  end
end