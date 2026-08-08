class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.111.0.tar.gz"
  sha256 "d2ce76719766961650d0b67faf83348bac850bf8c2b8da49213fb37ddb213517"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d132f4f6a7122582f3864c50c5cc34fdc4f9396f98c4f4aeacf6a29bced9d741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e13b2213280a6e5fce6144032534c03d3fd786e1d765e8f421b5f15ea6efa604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1673ae52681dd894b2644a24241b08784ab4a7aad9e6731fa43d8444df552d27"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff140d275c63efc6316e1679e05332048358025767b7b57d6d8a2ed0bc16165"
    sha256 cellar: :any,                 arm64_linux:   "a7a234b8af0278490874b9ebd6cedc97e316faff054818a0288f768f9336280f"
    sha256 cellar: :any,                 x86_64_linux:  "4e1e14e0ac7bfd1e95ab3b451c583f5b186823f9be5c59efa68f892b14a58dbd"
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