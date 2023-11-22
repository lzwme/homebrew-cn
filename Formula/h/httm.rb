class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.31.2.tar.gz"
  sha256 "f2621cc3e50848041e7b76ce2d813cde5dfe920b3c1c0987f61ed4bf5a416b83"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8809c06a4b25fd77d94378ab3e6bc6e5d678247e1746133cd89ebb5314fc1eaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba3e1097ae7b6dae6f84f2589809a31a99de0136d62c30dbe60c97f58fc2ffd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91b4c7cfed88a3acec07415e1a224d4b462ca14eff5e017e234e6664fcea0b38"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dc67d58104e2283f50937fb8f3482e6eabe770df08385b165b3b69873db2476"
    sha256 cellar: :any_skip_relocation, ventura:        "7254f18439efbb0645d557bf8631b4153703b6ee0494ef328470d853b080e529"
    sha256 cellar: :any_skip_relocation, monterey:       "347753eb59fb31c61a3d05d33c886530224910897d26f5f0eba42db39fbf74fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75dd9dd03f121d5ea57e9bd2ca1b9cb85464645f6df5bb7d2a5e8899d16d9883"
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