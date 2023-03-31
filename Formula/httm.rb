class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.25.5.tar.gz"
  sha256 "0cc96e18de250931fe2dc7f87f5c94d4b637a045b264e52e0fd2a7e70e4101ba"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c408c98d74b0749de8ae3e4b844c84b3782404b9ac61f62864966b53262c2d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d705516f415eedc64820e33def8881d9bf29b069beed24f1659ef00b57a3f72d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff70a8d77fb92276779a96600a9da301a8a504205be4baf98544c1f78b9738d6"
    sha256 cellar: :any_skip_relocation, ventura:        "1dc4cb1c36e6baf21c878df5b8a65110c32c81c5dcae00613cf3a519a94251a4"
    sha256 cellar: :any_skip_relocation, monterey:       "6c4c84f18e386c107183fd4e9007b96b5c966563d62170426830b0bf9e2d88e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc4a52787fd0ad2ce28ee8ec3650b80efc387ff353016fd41b768516faa08e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4ebd0c8fe673b7f07ac247416bc00c89fae7b4869d5954f3c1135b0b0530eb4"
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