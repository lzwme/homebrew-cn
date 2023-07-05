class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.29.7.tar.gz"
  sha256 "94b1eb3394b25e2bfafc37734ad32c8ee34bdf371b96bb72614bf940ff9b56a5"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8cb06fad8c8cae7a908b399b0ac0399c201cc461ad9de25f2fb897c4c0985d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a36c70862e38663fd668ef61bbad06e2a83e5637576ec3dff9ab25c01d1b94e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26a064a49c5ae00d653ebccf69ac3b28953f86f0b652baa9f8d9edcc3a6f827e"
    sha256 cellar: :any_skip_relocation, ventura:        "50f62cdf1550bbf56c456ba9e6965ac38a9f21258bf739b1a168edd56aa2e60f"
    sha256 cellar: :any_skip_relocation, monterey:       "5fec2f84d72c92858d5bf111c143f1abfebfe12bba8fdc7fdbb08c25efdafcac"
    sha256 cellar: :any_skip_relocation, big_sur:        "c372cc95b23e31ac403b8595afcfb08cf36de277926090c9d11dde9f243fb18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3a10e32d61afc3f7f211cb5188604c74ac6d55026fad21a8fbdf6c5b9f9396"
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