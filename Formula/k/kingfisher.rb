class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "8096d6346da6e356ba49756bc1811754731f9e2a45cdb3d6be5cb712af7f9c02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988322308aaf13e26972c8b0ed2aba9d39c53a456bb30d2b335bb0ff4d8d1e33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3617ef5e191e5643e8f4f64b8218c732fc5865b2972618dcd7854ef95bf0854"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6aad07d5f65a8a1c13c984cdc71d2d4a064c7f31c3244b96dfe4f09fe43b072f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cf1be7e8caaeb3971f8d2d13a99a2141f9ab14e0c56f7fd5aee91af8d485173"
    sha256 cellar: :any_skip_relocation, ventura:       "e7d59329c287051ddad924dff7bb6943a98eb7fb57e586222a45180cb4fbc277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fa966600fc2639956fa6825bd0fe6dcf51aa41aa7af177fd96d6f1b63553e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49c3af44bbb34f0aa8f3b9d39b96eeae6537d732a241b20047edef81ad428571"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end