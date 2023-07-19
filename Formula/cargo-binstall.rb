class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "041818319414611467ec201e34fc45e023a7f056c4b3576a71d4787c55c59901"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61b744ebe0e28ec718b35aa5769ea1b3099c4e7140b18c70449b4c74f0b17956"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09a85516a08618416f3ae4425a4b61e3e6545f82a3a2758675472265be677726"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17d95df363258f0ace68dd72687bfde6ee47a0f5764282132fb7f95a8fd28602"
    sha256 cellar: :any_skip_relocation, ventura:        "cc9675ab25136508be2b320ecea6a2d622cb89ac1b3e52bdac362119eefc2dad"
    sha256 cellar: :any_skip_relocation, monterey:       "14161ca3e9a54062d728bbc681e2019571c5c3081771633f80e81e680bfd6e61"
    sha256 cellar: :any_skip_relocation, big_sur:        "25f54e07b4a8ed012856720b43b1ae826a24e07578f3d5efbbdb108043961e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be3df8ffeb30882f388376d5eca08560ee5a47f4d4d533c2d1275e4d53fd0ac8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end