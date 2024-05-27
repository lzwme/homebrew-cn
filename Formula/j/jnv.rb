class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https:github.comynqajnv"
  url "https:github.comynqajnvarchiverefstagsv0.2.3.tar.gz"
  sha256 "87338cb8b3f8fbcfcfa4380ebeb3aa86e39f3bce57149f845ea76c9087e58f21"
  license "MIT"
  head "https:github.comynqajnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f58c488ce751be38f85a6f1fe1021017b876e45ca7150b7b1ab2c6bf181af551"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "315253bbc759e03f557272cee8740c6a733894b6672b767f9d3f0065e047a025"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3fc8e8cedb919aead85633a4ca5467f2fef67bb653280fb295b5e4c702fe7d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d97d234d25741479552f4ee1e4815fec0f4d286efb2ec8b11ef480b7a348f62b"
    sha256 cellar: :any_skip_relocation, ventura:        "8725c7cd6e15ebdea8c287aeda0731281444544c9a765070acc106d21cf45edf"
    sha256 cellar: :any_skip_relocation, monterey:       "9ed428372cc63e9010ee1ca5acc7713563d8db19a9436d696451cf852a1fc296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9cc78a4d39d1d410e644c38a01afa8a7d5cbdc2c174a820b4dce46b428c53b9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin"jnv --version")

    output = pipe_output("#{bin}jnv 2>&1", "homebrew", 1)
    assert_match "Error: expected value at line 1 column 1", output
  end
end