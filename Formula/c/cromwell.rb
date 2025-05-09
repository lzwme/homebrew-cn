class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https:github.combroadinstitutecromwell"
  url "https:github.combroadinstitutecromwellreleasesdownload89cromwell-89.jar"
  sha256 "afc761fc05b31a63a1157d112c64db77222aa2397dfd2f6c974dc44db689090d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d86293d84e263cb004ecd0240d4818ff8ca7d8a4219377d506e68cf9ba2b81d9"
  end

  head do
    url "https:github.combroadinstitutecromwell.git", branch: "develop"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  resource "womtool" do
    url "https:github.combroadinstitutecromwellreleasesdownload89womtool-89.jar"
    sha256 "beece815cbc7ddb48c49ef4511e1e794d6d2f3cb933f29265708a5c61c87fb4e"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "womtool resource needs to be updated" if build.stable? && version != resource("womtool").version

    if build.head?
      system "sbt", "assembly"
      libexec.install Dir["servertargetscala-*cromwell-*.jar"][0] => "cromwell.jar"
      libexec.install Dir["womtooltargetscala-*womtool-*.jar"][0] => "womtool.jar"
    else
      libexec.install "cromwell-#{version}.jar" => "cromwell.jar"
      resource("womtool").stage do
        libexec.install "womtool-#{version}.jar" => "womtool.jar"
      end
    end

    bin.write_jar_script libexec"cromwell.jar", "cromwell", "$JAVA_OPTS"
    bin.write_jar_script libexec"womtool.jar", "womtool"
  end

  test do
    (testpath"hello.wdl").write <<~EOS
      task hello {
        String name

        command {
          echo 'hello ${name}!'
        }
        output {
          File response = stdout()
        }
      }

      workflow test {
        call hello
      }
    EOS

    (testpath"hello.json").write <<~JSON
      {
        "test.hello.name": "world"
      }
    JSON

    result = shell_output("#{bin}cromwell run --inputs hello.json hello.wdl")

    assert_match "test.hello.response", result
  end
end