class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.20.1.tar.gz"
  sha256 "707ad4c912cb67a53ba55cd4818743774f0f3ecdf84aa092d1bc0c92ab770600"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d68baf72e45728db7115f0ba622ffe495ebd0e470aebf4f1faed3182deaf6d3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec9701edf9a9009b457629d8cc768b0d950f7dff6ce6ea948a4c193fae1402b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4ddb82c4a097989e5de0bb2daeb92fff2a00ecbd01632ee295353f9a641e4f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad67d5506e2785bc2436b0ff6d3ba40b60cdcfd6e3a2cbab6a6a486ae2830ffb"
    sha256 cellar: :any_skip_relocation, ventura:       "4487381de431bb97b3295c5d539377409a6c256910b763c2a07be75d8e170b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "534a70caad9a16c645ca6637e747d38790ea8a7273f11c496f212b3fb0d24452"
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