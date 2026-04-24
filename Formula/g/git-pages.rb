class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.8.0.tar.gz"
  sha256 "2bee2ac7ab1b001bf8c1d4260ab763be7e84d7f5c6c8dae794fd753cb49e25ba"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d27210517d96dfefc685d7ebaadc86bb7dd291f0d1e812c92d48bc2327bd4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a76e1f01a28fbcaad642488b577536a7c6f70faa078da3634342dc0bc6c59ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a24c36b242df6d9aae3a18c0f6545a4a69d4d616720780bf89939c4187236ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "15cc1e35a8ff2a7cc4e974fbf596d7e85ec251832084d95b7f96e140453c5f41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "052aaa5cb0be6ac71e2585ab2c1d55d7421412fe2297d5a0bb68b2cfd6157fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cd2b77de3413b0b8f5743c0271e6a98624fbfb459f74aa61c5adf82e78b1a8c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    mkdir_p "data"
    port = free_port

    (testpath/"config.toml").write <<~TOML
      [server]
      pages = "tcp/localhost:#{port}"
    TOML

    ENV["PAGES_INSECURE"] = "1"

    spawn bin/"git-pages"

    sleep 2
    system "curl", "http://127.0.0.1:#{port}", "-X", "PUT", "-d", "https://codeberg.org/git-pages/git-pages.git"

    sleep 2
    assert_equal "It works!\n", shell_output("curl http://127.0.0.1:#{port}")
  end
end