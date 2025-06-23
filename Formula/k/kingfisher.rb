class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https:github.commongodbkingfisher"
  url "https:github.commongodbkingfisherarchiverefstagsv1.11.0.tar.gz"
  sha256 "89620091e07cd340e8f2c3653254bf2ea1d3aad1f921999d0b44dbf7453d29e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead6f31ffb651889cd8a419788861f7e2d8ff42f2e0a0093606f894c6ee3b2c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e737c02f675636f4de63bb58f09a21d8233dffad4a1089cc723b7c32a66400"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "163a6e183201c7159573cc0772ebe8324eaeaf413b1f59f6e0b94d046e79b47b"
    sha256 cellar: :any_skip_relocation, sonoma:        "058741fd2c8cce81d0f14582abbe03e3866640c42b6c180844425fe47582a10f"
    sha256 cellar: :any_skip_relocation, ventura:       "cd3538f4d5a6c9ebf6a21562247bca6735601cb40e22c97b80371c943ca52903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70b3049dfc22e4b55efa2a850d58b44345a8329f97f429b4f935c77d5612e7f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba7fdba68c2733fe3d223c542bf14d3ae24ee627b949657581f74950b0a1110"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kingfisher --version")

    output = shell_output(bin"kingfisher scan --git-url https:github.comhomebrew.github")
    assert_match "|Findings....................: 0", output
  end
end