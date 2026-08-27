class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.15.0/pup_1.15.0_source.tar.gz"
  sha256 "4709e45553a634547a36b65de3486cbb8745a31ffdf2a1f6fb59454510445c7a"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb992fd69418356a3db877255f7d8e9829b2df562f9848f178cb183db8f23acd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd0716c373c76390ed726a2acf422db74068d165840e91fb2d9f878430eb94d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6417d17d4bd61cd2f804b150c0ee329bd2d70c8751318108fe579159c5533f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb5dd73b4c7e9088ea41c0707b600bba205845b8a0b6f20411ee5a1aab453097"
    sha256 cellar: :any,                 arm64_linux:   "9b090bf46c12dcc3ba3de1bf9c5b751df1efd5ec27732b53c5f5dbece79c76df"
    sha256 cellar: :any,                 x86_64_linux:  "eabe1ad61e76a163796adf6482147aa4a49fe13b09020982581cf582a46d2e2b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end