class TomcatAT10 < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-10/v10.1.42/bin/apache-tomcat-10.1.42.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.42/bin/apache-tomcat-10.1.42.tar.gz"
  sha256 "9b6f623a69fa0cc850125c895573ee657f7ee56608976ba26a9644b05e49fda7"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "542f6fb97456c49c488cbb40481a787430731f90832191bf31c33a9e59e789e8"
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
    assert_path_exists testpath/"logs/catalina.out"
  end
end