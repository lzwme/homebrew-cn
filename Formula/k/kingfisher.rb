class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "b63c547cd8fd8ed71017e544fd2be399c4aeb7b8ac71c1331edb73ec35c993be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09bead4701c15b81a7722bb0424302ee0b670c1e3940040e47632a88c5c9e80a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97782ca9c2755a88dd8beefbb80d1c75935f17866bc596cde6a635994290e980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b579a1e85307b1e0819274a6621a847635d0ded42d8166d367cc03c6b0748c6"
    sha256 cellar: :any,                 arm64_linux:   "a9cba6faf6349a5be5d29e10b19d7efbe5cf8ceac3f2fa5771c3d3efba560a46"
    sha256 cellar: :any,                 x86_64_linux:  "6ddc20dacac208bda95134fc5e0cd02c392b907eef76fadfaee7dc928efa0f8e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3" => :build
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