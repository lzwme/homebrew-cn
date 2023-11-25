class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.31.6.tar.gz"
  sha256 "2a22ad97a35a30041eeb64d0cb392d74e23ec6fa2ab97867aafe9fbe7596b617"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0831dde0be998ce1d456df1d1c7a76912fa428ede9a56efbf3b1b291dffda6bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "641f24e700db106da96c5633c5a7957ce411f3f8c22e4bc0765c4e6e951bc83d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dd754bd383e18c732749f7c6399af8a1800b6a11d07b01742ba34dbdc0eeba8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f743e0542c7365fc40cf02abc2d07fbe6ef46bcaed138d658027afb7a25704f2"
    sha256 cellar: :any_skip_relocation, ventura:        "c2c0e00ec61ae7141dcee28a7743ef42af82e61fd1ee351739168ff598bb79d5"
    sha256 cellar: :any_skip_relocation, monterey:       "fcbd1da41da884581cd87cd925f947dd81fa6f41360fdd61815034bfa8ba0903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bd762b808988fc384f20b8384fb31e0a97a39f37b656e7a79c8b0897a13af77"
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