class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "983f61d3967cbd05c874c5b75472f40e06ea27bcdd14f87b0f5e0ed8c2ec4a47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e37aed48e323cefa3bbef44bc705300a5b0867098af3e21135a08b6f95b2bfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f5fcfbe2337947750cd4157d5e35cfb857f055268b009e1ca71a89e8a58b4db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d84e8abf69d4b438015ac49eb8f359686e6a8de244f74a8dd5e8e6b3879b9245"
    sha256 cellar: :any_skip_relocation, sonoma:        "712b6fe5cacedc34c3233de6862363e81a7a6ca5447a8b7a916721ce0f2bae78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7386cfaa1ebe3dc9b03341b326d25dd235825a8cac8fdbe78ced2dd417ba15a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4187eab558916c06111f90aa55dba547eae64ba3801970d37507fcb0a0e3a1e"
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