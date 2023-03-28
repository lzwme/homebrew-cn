class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.24.3.tar.gz"
  sha256 "5781756d1f5cff1b82939d539b0a7a4a65877c5f814f3d97bcab6434879d0d06"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f425a49e3b1b5de9c5803d65d37c943fda79847321454c1fb845fbaaf9310a30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eb56ac38434df24454c54164f054b3ca006c9f7f1c728bdf6e2dc111ed07f48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a9aeea62d346496653797ce536eda8e4ab2be544f7dd157c5983c9390733db3"
    sha256 cellar: :any_skip_relocation, ventura:        "30353ca898bb5c5053937033adc26c0308ff6becedf070317a9d749c1a20fdfb"
    sha256 cellar: :any_skip_relocation, monterey:       "d57aca0ecf06302414689381760b07916c96680e84e4ccf2dca45608d936b186"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd6ffcfa52a2d5fddbfd5cd354b32286e3c70be36310000f0d17a19b39764428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b48ad95485e4ce314dbf81afdcff9a6b8cbf182fb9dc12e9a3a0a7cfaa7213"
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