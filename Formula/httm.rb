class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.26.10.tar.gz"
  sha256 "166f5cf435f48fd862c38a7e6117f342cdf1be265c579ae18542a3a1a1febe41"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19c970d2faafae6e8908d5ed47ee86554306becdfa477dcd344259fbeb132d77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c60f0dec2e11cf7e345c552967cbf0ef9d485782f143904c6eee1be5f3570f90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3561c2129c30da38ea8a18ce22b46e67ae4b580262c21da6b9722355dcb79f6f"
    sha256 cellar: :any_skip_relocation, ventura:        "e52a2e5dfa947b7f3ad34343c8a7d5ebcf3f8299a1a14298699b50cee61ef3dc"
    sha256 cellar: :any_skip_relocation, monterey:       "94f74728145552efe3c2c7fc51ac286012b669886ec73ca6add1024decef18c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d970222fbd643c2bd96b76f1ba27c053149a8e9b609659135bc3912abe16abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7110f85678fd868df138288c2c63d6328aad34d49b20d7a427d51ecb7c68fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end