class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https:github.combroadinstitutecromwell"
  url "https:github.combroadinstitutecromwellreleasesdownload90cromwell-90.jar"
  sha256 "d90e46f60f430ff627222c97b950c43f1ededc992619e0aeceaa334690d06073"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "77ff36ee803d9cb78860ed35bfdecdb440ec69d13f8dbf8a1b52d4c8f7ca5daa"
  end

  head do
    url "https:github.combroadinstitutecromwell.git", branch: "develop"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  resource "womtool" do
    url "https:github.combroadinstitutecromwellreleasesdownload90womtool-90.jar"
    sha256 "9a28348884e8ff858c1533c11bdb477a68ae527a04ba28a9e835eae33baee9ff"

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