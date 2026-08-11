class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.78.0.tar.gz"
  sha256 "33b195c87225d25ffe2552a6b37753f675ffb1b777593e8094c119395234686b"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e62fd500389172b4c6c0ee95f82a30f04b6c501bd58086125f834d342e7c7c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca3929b87dbc020e77c0d3c31fe2ba13bd2cb0b0deb847412d4f57995866bec7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76cd47693d9d3052b8d6cfbd06b4cacfe74735e6d2f6657d6431bbca743ff51d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e23ca0e8cbaeb2881143e905c6931fd4f94d101e1311440253ec2ac3b3151779"
    sha256 cellar: :any,                 arm64_linux:   "cca614dd1c4455697f9243fbc96e0d9175d1dc64f9fcc253b27054df5cb4b8e2"
    sha256 cellar: :any,                 x86_64_linux:  "d6ba6c5968edabd4958181014d3ffd0208f45126789346833bd9d915adf4dd31"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end