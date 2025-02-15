class Jsign < Formula
  desc "Tool for signing Windows executable files, installers and scripts"
  homepage "https:ebourg.github.iojsign"
  url "https:github.comebourgjsignarchiverefstags7.1.tar.gz"
  sha256 "bb6a6cc0fdcc9802b5ab47e7080601c94c545fa235c0feac242d11b9a2524d7d"
  license "Apache-2.0"
  head "https:github.comebourgjsign.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "398d1b30442ae333b029ad878b635c9f1301be644aa5b2b838de8eb93b039eda"
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