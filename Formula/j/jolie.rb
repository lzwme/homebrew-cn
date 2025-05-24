class Jolie < Formula
  desc "Service-oriented programming language"
  homepage "https:www.jolie-lang.org"
  url "https:github.comjoliejoliereleasesdownloadv1.13.0jolie-1.13.0.jar"
  sha256 "c400e65262dfc034ab085ac6fa97da9ebcbfc2a6572274e277b932ad92f360c1"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2ce7353769d3a48d2483748e5c6e918dc1804ebe0139500d590ae6904cf381a"
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