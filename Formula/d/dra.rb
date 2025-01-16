class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https:github.comdevmatteinidra"
  url "https:github.comdevmatteinidraarchiverefstags0.7.1.tar.gz"
  sha256 "6a607eeb65ed97703f746de228398ff560a812e7b6794eb654e96b5a64aacc1b"
  license "MIT"
  head "https:github.comdevmatteinidra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6fe9bbf58bce98cde75260ebdb7d95209ddbe2d767d11f12c22d6e68cae62f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44373d8586f6c80fd48133a75e6a02c5ec856d835e874e8cb8013acc6a1506dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ee97e77cdc48f5d9476bac172bf86c2489f0dbbda64b5f50ffc24f7dff6ea46"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c3791ce9979dba28d89e36752cf6fe296a186b6482cec5d44470c466ff9af5d"
    sha256 cellar: :any_skip_relocation, ventura:       "045b6b3b246446e6c1946c99636b22b529a890682252dbaea73b8ec210773536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc5b6e5a9aca874aafdef816e7830ed07a12a8bdc5267da624cf7fe70072fbf"
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