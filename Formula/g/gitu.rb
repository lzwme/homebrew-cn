class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://ghfast.top/https://github.com/altsem/gitu/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "40319c87aefb1626c7bfd63c30b12b845492fe33a4d154be4628fea8ba4e65de"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb3d6a4dd197ef10bd0c0cac11bad840a91f25dcc35169125e1e74f6b4bc8bda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9f4719c2e5e11792fed4046d9e831461ea0ffcfe6e7ece1a8db8b32355c7163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e04f0e11370c93cd3ca91644c4857d44d1e955b134d648449bea125ce19117ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "12a39ff7f0f1473551051df7bef610ae7c5a7d8757cde2c801e75a8a7cddab85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7c4ff24657b52304e46deccd533beade63f4931559cf38fb1f9b7a0151c2e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b7f6ad76a7a4ab5eba3e38c6463e3971d853cf0c27c64d653cff0f62a3c45d"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output("#{bin}/gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end