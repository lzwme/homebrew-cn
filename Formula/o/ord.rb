class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.22.0.tar.gz"
  sha256 "0945a392abdf35dbc974ac7121c90905e7e7278a7cbfa80310126d2501bcc7c5"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3e1eb9ff6e967826183781407167218db0efc446b419beff21b711318bcfe28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5072c8fb26c25cb3fb249b470e982a2a7c48f30ebffb839abda0994b9a9e9249"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70b2b1db8b48d0fce799ae77765c1f8e1edc6322868439ff4d4299071e5fd760"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb241b8acfb59b196fe72c358beb1c72ba782c950ba5cde9f2b534c2ca3be4f4"
    sha256 cellar: :any_skip_relocation, ventura:       "22daa51c42980c8934b7edc5fa89a6a3793dface64680728da9c5cedd93d89b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c5ce7e9fbcf2f462c6613c0ffa3ea84fcfc2fd07ad6b81626888c3022825e6e"
  end

  depends_on "pkgconf" => :build
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