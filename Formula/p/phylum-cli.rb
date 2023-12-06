class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://ghproxy.com/https://github.com/phylum-dev/cli/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "00c9cdfe1a8d7332fbd843c926107f60be511e22121fc2ecf5bb0d6d0e11c14e"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ee1f2777e6df7bc8fff74b328ef996c9cb3b1d84ca0cd3ba30118396b125ab6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7fea093883f244e69791d009726ead2a34a70dae97bfe5589ace518d034a7db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "896acc4b3eab38f6afdb16f3f482e3edd29a38d8c37c5f696486cc7914ff52ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "e070c6c674b7d09717b8fd3ff13c03f2d9acca3ac7f3ffb0f2eacc9873ccddfa"
    sha256 cellar: :any_skip_relocation, ventura:        "f63f739a84c3fdb083c30a476609d11f5f31a8abdae87ab269891a610be9c932"
    sha256 cellar: :any_skip_relocation, monterey:       "a1d97058022e2942724e82c4c1c77718f7c288a582f3066ba9c473a550234b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060ede2fb8d88dfd3c5a42d7d765d745581b124a30a8a0e219a0b6e3c08316a7"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phylum version")

    output = shell_output("#{bin}/phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end