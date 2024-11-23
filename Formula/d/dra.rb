class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https:github.comdevmatteinidra"
  url "https:github.comdevmatteinidraarchiverefstags0.7.0.tar.gz"
  sha256 "697923724bea9656507643687dc7fa6d95573b5e036b33af45d2b84d947b6a34"
  license "MIT"
  head "https:github.comdevmatteinidra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f6d4b206beb8b18729358bdfd5a45445936aa4a48f271d48c781bd0f357331e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "096ba75ef29c2a7051e89f83d71e7926d6fb7fd18cf8915a12263bdda415681f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "280a0337157b420e9147da5d3ed551e57a23b374b08011782937692d2234f8d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d240f6169a581385a1bde14f8798fa16bd0f61df12d98a66d691a5505da17d79"
    sha256 cellar: :any_skip_relocation, ventura:       "8fdc4c30807c4a6de9783e8206248b3402ffb503221ceb3e660a4757bc5d1156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752b8133269cc39b9fb70988ad6b2de988e56bf824089327badad07bd402722c"
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