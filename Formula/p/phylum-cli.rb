class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://ghproxy.com/https://github.com/phylum-dev/cli/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "a3dfc2840238c5c683ba650b4f4afb55aa31d209fd216b036e10d628fad6bd7e"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67414f093fac189d91b82657a91c279123dc381ccafec2405a86ed7c487bde7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "302008bc5daef360d062018aede5ab4beb06dabf1762d6fa30a0f95ea0278747"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c92a596b6bf0377691eb34683e0742d7c94c705b12bf8f4f3f7c7be6c9afbf59"
    sha256 cellar: :any_skip_relocation, sonoma:         "0245c9a0df691cee530bc6b46f9e7f3513b98fba57a4617cb5da9201659ade4e"
    sha256 cellar: :any_skip_relocation, ventura:        "52d1af37536783fe47924b1b25ade565f0833c211ad7d191cb544316c2735cda"
    sha256 cellar: :any_skip_relocation, monterey:       "9fd285bf68a1971e32bea0336fd5208c4d32858d35e331dee8f1022444987b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a721f706797ab437fa4bb9075b319a453e775776534368b47ec540acc8f7839"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phylum version")

    output = shell_output("#{bin}/phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end