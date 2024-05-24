class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://packages.scm-manager.org/repository/releases/sonia/scm/packaging/unix/3.2.0/unix-3.2.0.tar.gz"
  sha256 "5c3f680100cf6c21da951216841ef724bef70916fe39e4e99c7148bda3ddf27b"
  license all_of: ["Apache-2.0", "MIT"]

  livecheck do
    url "https://scm-manager.org/download/"
    regex(/href=.*?unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85d355f7a33dfc76c02572a09d6e24560d3bbba9ff141aef6600b36028c9a7f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c43d98d08622d597c9fd5c9a1b8555c28975641c4ad9f285817841f25a75765"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb94e731632972a2782a2eff30f4f98323a3259008186dc88a6708a8ffe903b"
    sha256 cellar: :any_skip_relocation, sonoma:         "da63f7d50aebec6955cddd25d50d66298e55be01bc2e24214324dbcf380bdf01"
    sha256 cellar: :any_skip_relocation, ventura:        "a715cc0430604ad6e217ec5bbce052aacb6c54bb68a88fee52755ba7e6addedf"
    sha256 cellar: :any_skip_relocation, monterey:       "7ec74b9fa71e832971d2203b5c5a4113cb2573afe693534612fb2695bccd9c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "430bd7b877696f9b7c92b0597a19ff69b5c15448a53302a87a435f0731f7a895"
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