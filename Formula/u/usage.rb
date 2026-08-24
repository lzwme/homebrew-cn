class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.1.1.tar.gz"
  sha256 "94becd7d3d8c9e1e803bed40fce3ae11282e412b76bf5d1a0f0b551da2dd4aeb"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "099f6fc1c0e15f41d216977db33b28be1843bca068a8908114bbba7a16aff5e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34a1890265ceef9d07f984f9b146e4b1054bc281d95f9edf28329db423b5dc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68fb441976d55c69c8f48373c6f91700cb07a91d1ab91f11bae0cb0ac2db5454"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ef574acd829bf0c6256d701e6694ca8d02585e1265920daea30ba8536920d70"
    sha256 cellar: :any,                 arm64_linux:   "0e960a6b3fdde4192c171331692bb41be8b4eaa568ffae70f5c5ab983828959c"
    sha256 cellar: :any,                 x86_64_linux:  "d19ee58a43ee9264a439948b3ec70b92431ce322f04a52fb51192aeb96219c35"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end