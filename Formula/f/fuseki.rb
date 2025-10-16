class Fuseki < Formula
  desc "SPARQL server"
  homepage "https://jena.apache.org/documentation/fuseki2/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-fuseki-5.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-5.6.0.tar.gz"
  sha256 "5833260ae40a4f0dadc92f11510ad836f00ef63f61ea25aabe16d02d697e818d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0aa04767b6bdcb434dd3addd18ccfa99c0e196ce28289b4ad940b8436d1df0b1"
  end

  depends_on "openjdk"

  def install
    rm "fuseki-server.bat"

    %w[fuseki-server fuseki-backup fuseki].each do |exe|
      libexec.install exe
      (bin/exe).write_env_script(libexec/exe,
                                 JAVA_HOME:   Formula["openjdk"].opt_prefix,
                                 FUSEKI_BASE: var/"fuseki",
                                 FUSEKI_HOME: libexec,
                                 FUSEKI_LOGS: var/"log/fuseki",
                                 FUSEKI_RUN:  var/"run/fuseki")
      (libexec/exe).chmod 0755
    end

    libexec.install "fuseki-server.jar"
  end

  def post_install
    # Create a location for dataset and log files,
    # in case we're being used in LaunchAgent mode
    (var/"fuseki").mkpath
    (var/"log/fuseki").mkpath
  end

  service do
    run opt_bin/"fuseki-server"
  end

  test do
    system bin/"fuseki-server", "--version"
  end
end