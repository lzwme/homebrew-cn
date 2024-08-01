class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-10/v10.1.26/bin/apache-tomcat-10.1.26.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.26/bin/apache-tomcat-10.1.26.tar.gz"
  sha256 "f73f76760137833b3305dfb18ed174f87feac3ab78f65289a0835a851d7cfeb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57c3c8c7c504dacc37937b041d6f46bfdc8e983bec0e5626c8d643c0e112434f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57c3c8c7c504dacc37937b041d6f46bfdc8e983bec0e5626c8d643c0e112434f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57c3c8c7c504dacc37937b041d6f46bfdc8e983bec0e5626c8d643c0e112434f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c9e5c88501c75661c2fbf9149034c7ed8dd3f0036e1c0f683a5bc91397fd798"
    sha256 cellar: :any_skip_relocation, ventura:        "9c9e5c88501c75661c2fbf9149034c7ed8dd3f0036e1c0f683a5bc91397fd798"
    sha256 cellar: :any_skip_relocation, monterey:       "57c3c8c7c504dacc37937b041d6f46bfdc8e983bec0e5626c8d643c0e112434f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41553c67ee1717794eef66213ef69482b2466c5beb0f8936b4097f6db974b82e"
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