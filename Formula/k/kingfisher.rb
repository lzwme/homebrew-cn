class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "c0635ed974781992a809ea2b9a8a76806b6a93934bdc7aa00d8f6b175a4c6f27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3adcf7e6df424accdf268d2d82d0337437b5f4433caf29c46bf993c279cf8625"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd39c3bc516c646063c776b6028ac16c735f50c0b3bc80dc70d1d1ee3d0fcc07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "101546073b7140b29d38597e2cbb6da3785ca10d4f2482627e0a8c10cfa9bd64"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a28bdca66256e251fbd5516ae6bffecdd5fa3777b43eb4cdb8c840b4c85a7cc"
    sha256 cellar: :any_skip_relocation, ventura:       "cd19acb88e5ce8b1177c39c9b8ba110171e6b3b3dbb20eb139809b22bfae480d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d722aa6a691724eff28444e2c2a6f90964fdfc1c6bed12c403d6487a9cee1e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bf582618af8c84a17e76af9e4055e680c689a764c5c2cb9c8d63cbfc38d2356"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end