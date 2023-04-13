class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.28.4.tar.gz"
  sha256 "6da13ad3d3d2ab6e00486aafc40e8fa6d77d7bb3cd4c3b246ac00a3ac61777e4"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04411dfdffdd8a6b95e303b7ef19faa759027f58390a71f8320fe0d5f0058b74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "629fb453d877651ad6f6e919694dbb0cf18dc9846bc3d3d8d873fb17f2861184"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "643122cba98ce311a6b3de97f5c3c307b1e1ca8580e3811a8a62692b0be75d62"
    sha256 cellar: :any_skip_relocation, ventura:        "f5454e531e28a07c42984a2fbcf5bd45d70c50cca5754b4c49ae2baff2c6e7a5"
    sha256 cellar: :any_skip_relocation, monterey:       "1b5969d396f438cc732a46d60ed32b2d5741897cd8e763fff740b820b8ded499"
    sha256 cellar: :any_skip_relocation, big_sur:        "39b7e9224f6ac234c1aa708f0989851f4fe693e8127bd00914652fe5899b8eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fec7ce462813cf5ba9f4b75e51986bd61aa622883a2114731cdaac3a9924b2a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end