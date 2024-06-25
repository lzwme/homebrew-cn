class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://packages.scm-manager.org/repository/releases/sonia/scm/packaging/unix/3.2.2/unix-3.2.2.tar.gz"
  sha256 "4b9715e5dc82f00ddaf0f40d2c5092b121fc630f84f30d51142bb1181d3f962c"
  license all_of: ["Apache-2.0", "MIT"]

  livecheck do
    url "https://scm-manager.org/download/"
    regex(/href=.*?unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b59171d2a8d569f23531480112b06f68b711e642f03c669c62d747b79857b69b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b59171d2a8d569f23531480112b06f68b711e642f03c669c62d747b79857b69b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b59171d2a8d569f23531480112b06f68b711e642f03c669c62d747b79857b69b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b59171d2a8d569f23531480112b06f68b711e642f03c669c62d747b79857b69b"
    sha256 cellar: :any_skip_relocation, ventura:        "b59171d2a8d569f23531480112b06f68b711e642f03c669c62d747b79857b69b"
    sha256 cellar: :any_skip_relocation, monterey:       "b59171d2a8d569f23531480112b06f68b711e642f03c669c62d747b79857b69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e1229fd774769e505df30d51edce64f2e56ea2bcc1662aec50c2f92196da8ec"
  end

  depends_on "jsvc"
  depends_on "openjdk@21"

  def install
    # Replace pre-built `jsvc` with formula to add Apple Silicon support
    inreplace "bin/scm-server", %r{ \$BASEDIR/libexec/jsvc-.*"}, " #{Formula["jsvc"].opt_bin}/jsvc\""
    rm Dir["libexec/jsvc-*"]
    libexec.install Dir["*"]

    env = Language::Java.overridable_java_home_env("21")
    env["BASEDIR"] = libexec
    env["REPO"] = libexec/"lib"
    (bin/"scm-server").write_env_script libexec/"bin/scm-server", env
  end

  service do
    run [opt_bin/"scm-server"]
  end

  test do
    port = free_port

    cp libexec/"conf/config.yml", testpath
    inreplace testpath/"config.yml" do |s|
      s.gsub! "./work", testpath/"work"
      s.gsub! "port: 8080", "port: #{port}"
    end
    ENV["JETTY_BASE"] = testpath
    pid = fork { exec bin/"scm-server" }
    sleep 15
    assert_match "<title>SCM-Manager</title>", shell_output("curl http://localhost:#{port}/scm/")
  ensure
    Process.kill "TERM", pid
  end
end