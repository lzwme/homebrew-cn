class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv6.1.0.tar.gz"
  sha256 "ce2b7a49310f29cb6fd1b3821ab958a0b5eecc5a2b3440c69ad171aa9c21eb0e"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95e60dd89cac2179771d997e584521ab2071dd03d4845f4e6635c9b02e2fe687"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f702f161c507392ebf4b0cd84bddda40da8131865ec4ca88fdfaf40c28cb2de7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e05292240e2f90d9423ad71097db87f93b2a49e4f7f6eb5ed401ead553a6f8a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8da52386565e2ccade8120d9cf6e69ac9921157037ad0460a21caddc454cd781"
    sha256 cellar: :any_skip_relocation, ventura:        "9df00792f60be94387a60107c297734df449dc4ef715bb3c42738d17e88a083b"
    sha256 cellar: :any_skip_relocation, monterey:       "5c0ac496fb3628d841a53e6cafea3f9e651d7b732b824485c168997408d57fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84cd252664994ffa678a427f37cfd60bcea0fdd716521269ae110d5795599575"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}phylum version")

    output = shell_output("#{bin}phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end