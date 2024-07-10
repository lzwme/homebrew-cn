class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.19.0.tar.gz"
  sha256 "81012747deee81b05cf72953e25c893acded449df377caef6f9aa824010d82f7"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c716f10dc9bd6f7896d36e700f7968e9336ec71dbb9ebd2abe9e91947eef2711"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f2cae43d85ff7e1f043ab94522cd9acf36fc5cb3d578a4241f65de13b98036e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5971861881429c71a088f8bd8a96f69531582bb0a99b39458d291ab6d274ee1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "af99c9e7c8257347db61ae1015a9c516475011423f11581a21a7b0fa2eea053e"
    sha256 cellar: :any_skip_relocation, ventura:        "6f3fadc6a7798b9b2e6c88d4641be51495e513b252a8986b7f6f29a6154d9837"
    sha256 cellar: :any_skip_relocation, monterey:       "d8e73a29a0baabd456039caf1110eac8221a1672f56f2010571be2e24b891316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8439e6a59d2e633f907e1521bbc24d8fa0a4d28ed9594942b7d1a5fc534baa1"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}ord --version")
  end
end