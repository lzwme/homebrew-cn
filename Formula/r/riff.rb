class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags2.29.0.tar.gz"
  sha256 "4c8bce997224a8afa2d5bb69733093fd12e160a6a633a748f89789d1c3d7ff7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d79c184e3474aac9902d673cd5cd3815b068adef8b60bd9ade681692427733b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b56db2f8f0547335fe2d3587c70331b319849c18a9036aefe864c0004ee90f9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f3a42f8aecea214c4facf3a5cbd97320ffbac5f05a9877cffafb93193f186a"
    sha256 cellar: :any_skip_relocation, sonoma:         "95b64568f87f6bdb39e5652481618f168e10196d34a367faab5f6dc282002ff2"
    sha256 cellar: :any_skip_relocation, ventura:        "38f5ae6a350ff1214c6a04fa3e98c69d82a10a581fa1345dca0c3c64773d0dc6"
    sha256 cellar: :any_skip_relocation, monterey:       "9c5684f91c852f2ce17a92d274d59e8a7af79fa61812eec922e4f4ea1e49da3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e65c0701734cd0b6d24f8ea3d3c9f9710ef32cff072ddc0bd096d5bec7dc1676"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end