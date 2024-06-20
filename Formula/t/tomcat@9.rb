class TomcatAT9 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-9/v9.0.90/bin/apache-tomcat-9.0.90.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.90/bin/apache-tomcat-9.0.90.tar.gz"
  sha256 "318491c4be43494e6872b5277c40cac8506901d744ad09d37df62e88543f6223"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cd770729d57646c044dadf0a6da9555a658c9ff6ff2a8c50694f4259e8c744b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cd770729d57646c044dadf0a6da9555a658c9ff6ff2a8c50694f4259e8c744b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cd770729d57646c044dadf0a6da9555a658c9ff6ff2a8c50694f4259e8c744b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cd770729d57646c044dadf0a6da9555a658c9ff6ff2a8c50694f4259e8c744b"
    sha256 cellar: :any_skip_relocation, ventura:        "7cd770729d57646c044dadf0a6da9555a658c9ff6ff2a8c50694f4259e8c744b"
    sha256 cellar: :any_skip_relocation, monterey:       "7cd770729d57646c044dadf0a6da9555a658c9ff6ff2a8c50694f4259e8c744b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49cf6dcf30d756af974bfe7342d0fab0c80134ca201436c9a311f91eb460ef15"
  end

  keg_only :versioned_formula

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
    (bin/"catalina").write_env_script "#{libexec}/bin/catalina.sh", Language::Java.overridable_java_home_env
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