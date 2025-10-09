class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "7ae5fa4202b6761df276665b65b2870abd80f81c8f88d3a6795a5bf71ab3d901"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6228874aedb739a3abcb781d6cacad7b1638264704a8b8b33e7e0067145891b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1257a96665c3909328079e0de3a7870a217d5569d3f1a28ef28b2d094d1f4a6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "610b580bdc3cba822a45325132dfb29bee0e2c2b5e9d0de1a0861b77ffc64b87"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce4da4a7275d1c35762bb2165785f7783e482e1675e987b36445eac107b88884"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f9742c4f66c3b58c6ee67f0542cfda4ef59e28b22c48cc52e00c800b3534a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96a6486f49d2b2e24990eefdfd40fb782801752d2afaa3f5d24646c1bd181533"
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