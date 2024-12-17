class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https:github.comynqajnv"
  url "https:github.comynqajnvarchiverefstagsv0.4.2.tar.gz"
  sha256 "12f23a6082afbb80e567222ebfb827d71c08fb343473c1f909f5554aa9a4867f"
  license "MIT"
  head "https:github.comynqajnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0cf70293e7111aec8fcc6ff7d8782df0a64324fa9aba266556e9ada1ec0a6bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "435612947d9def4bbd93299bd0a642574a290a85fa85555e89d4421bb7a1da27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4ae1af80dd9b3e71cdb82ac43cfb314ad39abdae7b67d91185472c085957262"
    sha256 cellar: :any_skip_relocation, sonoma:        "14c45837cc6aabe8acb4664dd207f60996bc371ee02af9b4df3fa6fa0a6ec00f"
    sha256 cellar: :any_skip_relocation, ventura:       "4c646d3a72b8931e85298c85db9dc673d8fe6785f93bac9ce0dcd07bf103daf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a99e6ff1cf644ca2cbcc72ea2443508e6f0ff5ab2eed863ff51c55559af0bd9e"
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