class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.110.0.tar.gz"
  sha256 "92ff4d8b98ecd0eb0897ac78dd4bd36b416454f74ed13fbd5ef4168b6bca7bde"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b36ffcd57e73c40fdd07f5acd0660fde02ab232d47b2e89b6124e69902ff9fa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4345e0c78f9728f401b14d1aa32f2530952f173f8a52015e02577735bb589d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bf6185e5e3a916bc718f1c8f366005bc2275a257e8e8134452ddaa2e5ad96b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "022477f5f43482b32316f1ff61ab6ff5b49812987392b6b9c713214bb13ebeb9"
    sha256 cellar: :any,                 arm64_linux:   "9b89a78146f1e2518cf81698b16fc5cdea948a3f37bc5984e926a1360b7d8822"
    sha256 cellar: :any,                 x86_64_linux:  "82a26498c833e7c6bf79b95184ba1a049d8dd71a3158b0483896518c7ddc9ae7"
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