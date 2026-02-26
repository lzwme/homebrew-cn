class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://packages.scm-manager.org/repository/releases/sonia/scm/packaging/unix/3.11.5/unix-3.11.5.tar.gz"
  sha256 "c1103ca34279ab3547aabc7051a7c1c62fbde576cdd30f1b4fcf834ff2ed1669"
  license all_of: ["Apache-2.0", "MIT"]

  livecheck do
    url "https://scm-manager.org/download/"
    regex(/href=.*?unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6099ad912788d0206e34c8aab5f83feab56ce1136a5dd1e029082b667fcf1dc7"
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
    pid = spawn bin/"scm-server"
    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/scm/")
    assert_match "<title>SCM-Manager</title>", output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end