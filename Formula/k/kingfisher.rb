class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.101.0.tar.gz"
  sha256 "73a03c0892ad36edebb3a2a68a86e5197d63c7b6b4910d93c977df6daa711d09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e5ed727a678d015f187731e891c52bb6f3227bef43fda29cf87e71df82e9e21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92f607632de55244a3e2ec180c58a7fefb965f045d6e854a76dac2fe05ae8b96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c2b58c3872af4ffe040bf9274a6021aa66ad9cfab51036fbf2027c6fada7955"
    sha256 cellar: :any_skip_relocation, sonoma:        "13f505ba9181479f477a83d4d5995c232bf924d2a53ed7adf5c1bdd846ae7016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92a1636cf0c83a10736a0ca8bffef1487f79c63c37edf4e6f565dad8aa5e04db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "195df8c36511624286b9d4d03d7acffaf111f505f0c7c955c2f1d68b998c2f26"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end