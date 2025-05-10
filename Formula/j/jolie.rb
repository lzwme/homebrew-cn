class Jolie < Formula
  desc "Service-oriented programming language"
  homepage "https:www.jolie-lang.org"
  url "https:github.comjoliejoliereleasesdownloadv1.12.5jolie-1.12.5.jar"
  sha256 "69dfaf3724da1202a10e0a44068778da8b5c2258f0e7166365ea7e9522320de8"
  license "LGPL-2.1-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "690e57262402203f7eea7feeeb08cb23c8f6ddc4c6680c998d1b141ed42b4ec2"
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