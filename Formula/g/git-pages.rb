class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.6.2.tar.gz"
  sha256 "a3b04558760e531ac4b80e0c7eccad374ce67689d385b86010e3b34632ffe077"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b2d559afe7f15c20b6e9a8429183f2b52fe5ee82569a974a16aaddcf6d9b8e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e67d72ddfc5566fc5c300adf901a043daa6943033eb90341e221cbd37280c763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16f297601b706ee6746722bc9667c4e3def6699fcb72a0202404900ba03e3860"
    sha256 cellar: :any_skip_relocation, sonoma:        "72a18b2924b898cccff2e265fe2bb8601e8988adc129f3cc714d5750b03d8e1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "906c0d7e7987f5506586278b9573ad8bdb11687f292033bfc9d6a59e0b4a752b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f39592ad113bc76d44c611949af0748e8a3bc159c43e444dc7ceeb9ccebe3142"
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