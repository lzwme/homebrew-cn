class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://ghproxy.com/https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "9ee633b0de18b3cc2b6246c596b6b752a888e56203b8bc59db10dd7a8e4fa70a"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5249dc53e9768a8a739df1bd7def2712e89c1ef5b48b9a2b72f4993b3dd728f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c4b5faad3e9315a70cbfab2c449d76f8eff8f60b3216fb289e373b4b5512c9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "660b331becc115094df1a46168a9f824e31749aa10d983cbe53c386ee539d63a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1098cf5e7c49c60fe611ffb9bed6bd328eefd8869ac08a5250a0182ff1567a1"
    sha256 cellar: :any_skip_relocation, ventura:        "b4ad1ff77fdd6407a031380b72b3ed0cf2e47638c0639139f9b5d52f80681248"
    sha256 cellar: :any_skip_relocation, monterey:       "13fa18ebdba0a738870fdd825d3273598ee3e83c260d5226f3df44a4ec334682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96380970ea66d0b1c74512ed64bd395d4d275cb2726575567343d6f323f531fe"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--no-default-features", "--features", "openssl-tls", *std_cargo_args
    man1.install Dir["target/release/manpages/*"]
    bash_completion.install "target/release/completions/crunchy-cli.bash"
    fish_completion.install "target/release/completions/crunchy-cli.fish"
    zsh_completion.install "target/release/completions/_crunchy-cli"
  end

  test do
    agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/119.0"
    opts = "--anonymous --user-agent '#{agent}'"
    output = shell_output("#{bin}/crunchy-cli #{opts} login 2>&1", 1).strip
    assert_match(/(An error occurred: Anonymous login cannot be saved|Triggered Cloudflare bot protection)/, output)
  end
end