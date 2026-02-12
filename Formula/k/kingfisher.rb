class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.81.0.tar.gz"
  sha256 "e9c3d8593aafaabf4f195324adfa664ee2d95db852be8aa5efccc080457e837c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dad7544d3592ba1cfe37b7f88a9436ffa2aa89ee587c51f317b0d14731516dd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a74c530ee3a4220a2eabd318e2883b4894f8304cca3a47294ee0a6802faf4ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "981eee9c29da2c43bec83ed3b2a98b4a20fb6511d51b7c8018bc324faabe47d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d2855e0b87d7fbe619d21b1d4efcda10bfd0c8666a96cc225cf50a348431e09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4e85fd580ecc7ab836fd89a127245684761a80f779d696db81dfd664a14cac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0720e8ec3d6fa868143150c5b093eba589e1f7d5d05ed1b975803ec51fa70243"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end