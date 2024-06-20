class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-10/v10.1.25/bin/apache-tomcat-10.1.25.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.25/bin/apache-tomcat-10.1.25.tar.gz"
  sha256 "f1240a32b879c445a4a4419c9b6dd87581bdb96f8a51f7b0ca1935164bb1e842"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b15db51b6c1c4d53f05d8376a62187f8398e92b33604c2e3feed0f57251471e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b15db51b6c1c4d53f05d8376a62187f8398e92b33604c2e3feed0f57251471e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b15db51b6c1c4d53f05d8376a62187f8398e92b33604c2e3feed0f57251471e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b15db51b6c1c4d53f05d8376a62187f8398e92b33604c2e3feed0f57251471e"
    sha256 cellar: :any_skip_relocation, ventura:        "7b15db51b6c1c4d53f05d8376a62187f8398e92b33604c2e3feed0f57251471e"
    sha256 cellar: :any_skip_relocation, monterey:       "7b15db51b6c1c4d53f05d8376a62187f8398e92b33604c2e3feed0f57251471e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e4dfae152d0351443d173ab3044ea64afd6889db41c6e45a3adf4b7a726df2"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]

    pkgetc.install Dir["conf/*"]
    (buildpath/"conf").rmdir
    libexec.install_symlink pkgetc => "conf"

    libexec.install Dir["*"]
    (bin/"catalina").write_env_script "#{libexec}/bin/catalina.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  def caveats
    <<~EOS
      Configuration files: #{pkgetc}
    EOS
  end

  service do
    run [opt_bin/"catalina", "run"]
    keep_alive true
  end

  test do
    ENV["CATALINA_BASE"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{libexec}/logs/*"]

    pid = fork do
      exec bin/"catalina", "start"
    end
    sleep 3
    begin
      system bin/"catalina", "stop"
    ensure
      Process.wait pid
    end
    assert_predicate testpath/"logs/catalina.out", :exist?
  end
end