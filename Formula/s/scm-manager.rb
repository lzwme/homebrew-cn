class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://packages.scm-manager.org/repository/releases/sonia/scm/packaging/unix/3.2.1/unix-3.2.1.tar.gz"
  sha256 "6e9859b48da74d51a10d547d7310101e728d3b46054ec292c9bd4e1c6e0cc51b"
  license all_of: ["Apache-2.0", "MIT"]

  livecheck do
    url "https://scm-manager.org/download/"
    regex(/href=.*?unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03dfd10f31387e0dd5fade0f69ca4c33bf78b2b7d534597c89ef5e35ece005d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03dfd10f31387e0dd5fade0f69ca4c33bf78b2b7d534597c89ef5e35ece005d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03dfd10f31387e0dd5fade0f69ca4c33bf78b2b7d534597c89ef5e35ece005d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "03dfd10f31387e0dd5fade0f69ca4c33bf78b2b7d534597c89ef5e35ece005d4"
    sha256 cellar: :any_skip_relocation, ventura:        "03dfd10f31387e0dd5fade0f69ca4c33bf78b2b7d534597c89ef5e35ece005d4"
    sha256 cellar: :any_skip_relocation, monterey:       "03dfd10f31387e0dd5fade0f69ca4c33bf78b2b7d534597c89ef5e35ece005d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18221ab74c8ecddfa494132e5baff963ef15b9a5c6912d601dedad671279d716"
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