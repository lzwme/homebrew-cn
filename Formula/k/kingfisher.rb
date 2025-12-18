class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "892c8ba576b68e8b75613a3065d4ce211075f30288b38a693e91738b2671036a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5c1a4702df96a67a3c32759ff11bca8c175594b846fddac7cee6481f587a125"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f7a32b7c9c86cd252a747c525e0fe0c537b5c738b9aad5f73196403b76360a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "563833afb61169e07845588b795173dc8acea8f12214e00804d97db59e31b05d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8528567571f29f31c7090d62c6796a3c284c23e4c0a9afa783345deb2b6de1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3c7f1c15f0907fa0f4650b195c8143d0b22c94789f77d2caf220e6868a5335c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eecd4ab37dfeea3f579d441c620618fd29f61601ab7b4d3195e90a701831833"
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