class TomcatAT9 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-9/v9.0.91/bin/apache-tomcat-9.0.91.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.91/bin/apache-tomcat-9.0.91.tar.gz"
  sha256 "0c5b29ca1d3a31bbb8fab6ad1feed8a3702ed325d14839550a6774c76c90b856"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81411a5152288067fdadb290f55ffc6a0498be7a27372108ea9eb12990d47f90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81411a5152288067fdadb290f55ffc6a0498be7a27372108ea9eb12990d47f90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81411a5152288067fdadb290f55ffc6a0498be7a27372108ea9eb12990d47f90"
    sha256 cellar: :any_skip_relocation, sonoma:         "81411a5152288067fdadb290f55ffc6a0498be7a27372108ea9eb12990d47f90"
    sha256 cellar: :any_skip_relocation, ventura:        "81411a5152288067fdadb290f55ffc6a0498be7a27372108ea9eb12990d47f90"
    sha256 cellar: :any_skip_relocation, monterey:       "81411a5152288067fdadb290f55ffc6a0498be7a27372108ea9eb12990d47f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c749b1162aee583327345c6ddbefa64f0e9328da0ca7f5b383fb2a610ee2325"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_r(Dir["bin/*.bat"])

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