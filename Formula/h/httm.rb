class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghfast.top/https://github.com/kimono-koans/httm/archive/refs/tags/0.49.3.tar.gz"
  sha256 "ed925a6ff29132709c9da9cf6acb54a67a571a4ba81f6b55ff3390531c9d74f7"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d87c3f4f29c327cb7f31d0d022ee347bbb1a0a893aff478388f17f92e5610dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6335e78078bc768eb2978d41021826468c4f3a3a3ed7d9271de127ce15ccea95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f752683556e96dcb1ef38c1794befe0de2099db74b4ad764d81bf0424c3e8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7981d86d33ea249c5d8d79e55b957ca0c1a91b9a7b9d7cc9df1f46dd09306c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6338046111e8fdb9ffd3f3180fb6ffd6c298a2ef66adf3311cfbf3d63ace11e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f5aba1379d2f04fa91d2515716e7720742d22e0e78cb713ddfb53c2725b5386"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end