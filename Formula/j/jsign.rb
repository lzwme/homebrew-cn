class Jsign < Formula
  desc "Tool for signing Windows executable files, installers and scripts"
  homepage "https:ebourg.github.iojsign"
  url "https:github.comebourgjsignarchiverefstags6.0.tar.gz"
  sha256 "df98690164440627bbecab7498690231c80fb19a68cdf7784b88e19ba24bd7a8"
  license "Apache-2.0"
  head "https:github.comebourgjsign.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b00098005ac7db789bb40bbb7586303706bf40ecb565c00cf16e72da8973afab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f22c6ddf024d78f5e251838dfe6737906048a265d6186a487183d03eb75fb65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fa5c59d84abae2fcf6df7f6b4de93e6f8f366a8ab49e3f08274e5a57b8e42c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff260c3a23a688662cddaff0704a35b36333dfbf8ecff36ef264b22ed01a2637"
    sha256 cellar: :any_skip_relocation, ventura:       "1f014aa2f1412a040d6c997e4fae0038168fa8d793cc94fd7be648d5b189ad9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fa5c59d84abae2fcf6df7f6b4de93e6f8f366a8ab49e3f08274e5a57b8e42c8"
  end

  depends_on "maven" => :build
  depends_on "openjdk@21" # The build fails with more recent JDKs

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "mvn", "--batch-mode", "package",
                  "--projects", "jsign-core,jsign-cli,jsign-ant,jsign",
                  "--also-make",
                  "-DskipTests",
                  "-Djdeb.skip",
                  "-Dmaven.javadoc.skip"

    # Fetch the version from the pom (required to build from HEAD)
    require "rexmldocument"
    pom = REXML::Document.new(File.new("pom.xml"))
    version = REXML::XPath.first(pom, "string(pom:projectpom:version)", "pom" => "http:maven.apache.orgPOM4.0.0")

    libexec.install "jsigntargetjsign-#{version}.jar"
    args = %w[
      -Djava.net.useSystemProxies=true
      -Dbasename=jsign
      -Dlog4j2.loggerContextFactory=net.jsign.log4j.simple.SimpleLoggerContextFactory
    ]
    bin.write_jar_script libexec"jsign-#{version}.jar", "jsign", args.join(" ")
    bash_completion.install "jsignsrcdebdatausrsharebash-completioncompletionsjsign"
    man1.install "jsignsrcdebdatausrsharemanman1jsign.1"
  end

  test do
    stable.stage testpath
    res = "jsign-coresrctestresources"

    system bin"jsign", "--keystore", "#{res}keystoreskeystore.p12",
                           "--storepass", "password",
                           "#{res}wineyes.exe"

    system bin"jsign", "--keystore", "#{res}keystoreskeystore.jks",
                           "--storepass", "password",
                           "#{res}minimal.msi"

    system bin"jsign", "--keyfile", "#{res}keystoresprivatekey.pvk",
                           "--certfile", "#{res}keystoresjsign-test-certificate-full-chain.spc",
                           "--storepass", "password",
                           "#{res}hello-world.vbs"
  end
end