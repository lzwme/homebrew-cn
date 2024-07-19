class Fuseki < Formula
  desc "SPARQL server"
  homepage "https://jena.apache.org/documentation/fuseki2/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-fuseki-5.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-5.1.0.tar.gz"
  sha256 "19cc1770b54cdadc4f0be9241e3108a6a2bd75391010df499246b411a2513bb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f44dda213f4230b6eb0cc41fbffc7a22760de441e22875f35a9f05b3ddb00e3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f44dda213f4230b6eb0cc41fbffc7a22760de441e22875f35a9f05b3ddb00e3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f44dda213f4230b6eb0cc41fbffc7a22760de441e22875f35a9f05b3ddb00e3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f44dda213f4230b6eb0cc41fbffc7a22760de441e22875f35a9f05b3ddb00e3d"
    sha256 cellar: :any_skip_relocation, ventura:        "f44dda213f4230b6eb0cc41fbffc7a22760de441e22875f35a9f05b3ddb00e3d"
    sha256 cellar: :any_skip_relocation, monterey:       "f44dda213f4230b6eb0cc41fbffc7a22760de441e22875f35a9f05b3ddb00e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e3956585094480502279735cba84a79bbe82869518b392f480e55cffe74a07e"
  end

  depends_on "openjdk"

  def install
    prefix.install "bin"

    %w[fuseki-server fuseki].each do |exe|
      libexec.install exe
      (bin/exe).write_env_script(libexec/exe,
                                 JAVA_HOME:   Formula["openjdk"].opt_prefix,
                                 FUSEKI_BASE: var/"fuseki",
                                 FUSEKI_HOME: libexec,
                                 FUSEKI_LOGS: var/"log/fuseki",
                                 FUSEKI_RUN:  var/"run")
      (libexec/exe).chmod 0755
    end

    # Non-symlinked binaries and application files
    libexec.install "fuseki-server.jar",
                    "webapp"
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
    system "#{bin}/fuseki-server", "--version"
  end
end