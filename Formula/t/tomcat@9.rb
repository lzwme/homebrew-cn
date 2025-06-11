class TomcatAT9 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-9/v9.0.106/bin/apache-tomcat-9.0.106.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.106/bin/apache-tomcat-9.0.106.tar.gz"
  sha256 "1013311960cbc88be6d87ef946c685e16052a0d9d1a76e35d3d1ac4191b8e27d"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "659885498eef93d33f70ec9a72d419cfbab6e8c6307c1022f8c71721758f8791"
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
    assert_path_exists testpath/"logs/catalina.out"
  end
end