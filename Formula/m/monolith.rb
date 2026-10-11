class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://ghfast.top/https://github.com/Y2Z/monolith/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "cbd9f133867164fa80ad4de8dd8b0f1e93c8129c949d26d7548e0f18a03ec6bc"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae29d77c77f845f4bbad865611aafc1a8f9b025318daa924b1dd0709c980c730"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b1e7dfd94e12cf6a64ea02a6d7e2a1cebb5eb4d13be9257fb99d5f53c947967"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f884054114f0a333cdc8e9b92a29515df2e79b6f21ecc0dff442dd6ca7558399"
    sha256 cellar: :any,                 arm64_linux:       "dd73bf03e24ad688ab8dc0e1b5e7205b0f4d31b8f898da1f336bc44e3200cb98"
    sha256 cellar: :any,                 x86_64_linux:      "a5d99102fb2dab01c6028b5564d0f4e3f67844474750f3894625e70c9ecce174"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end