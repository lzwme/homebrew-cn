class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://packages.scm-manager.org/repository/releases/sonia/scm/packaging/unix/2.48.1/unix-2.48.1.tar.gz"
  sha256 "e8c8b1045f055905defdca21521b631f8267e8a58a784f1a78d92e8cc4d2374a"
  license all_of: ["Apache-2.0", "MIT"]

  livecheck do
    url "https://scm-manager.org/download/"
    regex(/href=.*?unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b062caf20dae38dc1de039b1b29a9925e720876853fa14db4755dbc3c7c613f0"
  end

  depends_on "jsvc"
  depends_on "openjdk"

  def install
    # Replace pre-built `jsvc` with formula to add Apple Silicon support
    inreplace "bin/scm-server", %r{ \$BASEDIR/libexec/jsvc-.*"}, " #{Formula["jsvc"].opt_bin}/jsvc\""
    rm Dir["libexec/jsvc-*"]
    libexec.install Dir["*"]

    env = Language::Java.overridable_java_home_env
    env["BASEDIR"] = libexec
    env["REPO"] = libexec/"lib"
    (bin/"scm-server").write_env_script libexec/"bin/scm-server", env
  end

  service do
    run [opt_bin/"scm-server"]
  end

  test do
    port = free_port
    cp_r (libexec/"conf").children, testpath
    inreplace testpath/"server-config.xml" do |s|
      s.gsub! %r{<SystemProperty .*/>/work}, testpath/"work"
      s.gsub! "default=\"8080\"", "default=\"#{port}\""
    end
    ENV["JETTY_BASE"] = testpath
    pid = fork { exec bin/"scm-server" }
    sleep 30
    assert_match "<title>SCM-Manager</title>", shell_output("curl http://localhost:#{port}/scm/")
  ensure
    Process.kill "TERM", pid
  end
end