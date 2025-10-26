class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "57662c24177ff5eff676a9dc4b05ecd9b67fe22d5b185283ee7c1c5a10e9405a"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e75fca3de40605f66ce80ad04b68dd8291fafaf58fbbcf6c7ca144486a1bd6f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d0f3bf658931ad94eb18dbc3893132982b9ee7b89b64da43a3f5005ec933212"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a1a63a643ddd532f15e964701356fb54f4c8da44d202af3c0bb04c666edc0ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f81687e463a54b1fa29963748d6bb816db3a32495d10143ab0894ae696df1fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e271592ff1cb2ad974fa47569a022774c55507a497314c6d5254c61a86a763aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c619b33202bb3da75455329c7f316d13b1f6fd04249d48b9a8a5d2094c11813"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end