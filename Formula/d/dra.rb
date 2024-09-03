class Dra < Formula
  desc "Tool to download release assets from GitHub"
  homepage "https:github.comdevmatteinidra"
  url "https:github.comdevmatteinidraarchiverefstags0.6.1.tar.gz"
  sha256 "cf6d96c8c76472a51c5bf651732715682ba8f11ce9d61dca67c1baa6bb421bc0"
  license "MIT"
  head "https:github.comdevmatteinidra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ab1101b6385bf05ce85c314c3efd4c7610f70f31465a9de24698e048fd99e50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29636e0855a0716e7c360e18a95dcb8e2153408b747ea10ff65ac4e32bb0e17a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "667b94923840f294b552b8b78a406dc092f7d9872da12f5b52073648deb9dfcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecc8e57b019505a0fa302dbc475d306550d724bfc0529471b439d54846aa008e"
    sha256 cellar: :any_skip_relocation, ventura:        "c17547627808ee97669214ffe50d02dbcd12757750570281e4ca61ce27ed3465"
    sha256 cellar: :any_skip_relocation, monterey:       "1fe05449b1fcc6b5bafecfe171c68e619e0d8872a50e3d345ed7e1f373670af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fd6e33dbfa4f2f7fbcfcbf326c6462ef9248215eaaae1c4d0692d8f50e4034b"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"dra --version")

    system bin"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteinidra-tests"

    assert_predicate testpath"helloworld.tar.gz", :exist?
  end
end