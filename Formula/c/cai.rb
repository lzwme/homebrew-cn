class Cai < Formula
  desc "CLI tool for prompting LLMs"
  homepage "https://github.com/ad-si/cai"
  url "https://ghfast.top/https://github.com/ad-si/cai/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "5a2cc76aae7ebbc691ac5705749c254c95fda1c423418da9dfc869503a4229a6"
  license "ISC"
  head "https://github.com/ad-si/cai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10066b2e96f16dc0681eaf8dd0c7f1d45eeeb186a60851f574e56d974b454fed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6c28602f9becffda01d14b00077c86fa37bcec505c6d0dd3e8dcd5ebb5c2f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bd15f5f38ec3dbad94655de21795ed0c9cff38b6a43e0b735b394733a248c89"
    sha256 cellar: :any_skip_relocation, sonoma:        "11ce5aacb61094972573f20bcdfc19a60cd92a15ac85ac0ceba73380197fc363"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8a42a7cffe0190994590066e61edbc2473411362f304551b16cc3c822628dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6071ae21961e161a8ed5f748c3611b8d604503b48cb39515516f3f14dfb99f51"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cai anthropic claude-opus Which year did the Titanic sink 2>&1", 1)
    assert_match "An API key must be provided", output

    output = shell_output("#{bin}/cai ollama llama3 Which year did the Titanic sink 2>&1", 1)
    assert_match "error sending request for url", output
  end
end