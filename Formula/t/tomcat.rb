class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-10/v10.1.29/bin/apache-tomcat-10.1.29.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.29/bin/apache-tomcat-10.1.29.tar.gz"
  sha256 "93d92527d467fff094d45db1cabbe1a2cefb92979779a44f2a50d053b4155ce3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e60802ddf63effd31dca0e6704d1dd8f78faaa40e7a5dd5c1f9e4f865ee035bc"
  end

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