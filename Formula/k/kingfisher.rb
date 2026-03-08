class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.86.0.tar.gz"
  sha256 "cb3dbc710725284642c362dbf5692639eec7f57cf8f56d1011082213e65463ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cd505fa7cf0549c01ba714d191d9c30cd0b1b1a631f0fa30a23a3bb63df6641"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c969af3fb9d2f8b0826908c2300f40c192bb4cb37cf80e43beb411c912b04000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a88da1f47f0f72d9ce5a59007514497876c8964f52b6fc97c81f3f51c25c23fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a2c34fa6e9f599d38c0be1e607a7656fec2d7d0250866b3989ead489beee608"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e71d0517b906776f0b27c58b472ac6f9b8010aed50c915f34393c6f430f68785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f118f5053d4fc941f2546d103685c7f9d6d9c6f3fa3ac93ed9db6c18fe6fdfc4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(features: "system-alloc")
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end