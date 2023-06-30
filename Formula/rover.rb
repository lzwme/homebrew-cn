class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghproxy.com/https://github.com/apollographql/rover/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "e46f18e6274a6a769a2bebffa24f9a9d7fd9b7228c9008b1afa2ddc1055f76f6"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a466a9b9bad89deb4502e37448bf7891c6231acb1fc1ea1c406443aaa0a494d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6feee304f8237b3dfbbfcff61dbb32b5e4576eefa4953fb64122cbdf7a280088"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "158f79be671594b09081e2a1406ce17f8cd4aa13b8d6eac66469ef3e26c3f8c1"
    sha256 cellar: :any_skip_relocation, ventura:        "dcdebc691b8f233a4d346dd16b668490a68c3e69a4ddc32a91ea00d12c1742ab"
    sha256 cellar: :any_skip_relocation, monterey:       "dbd86ccd3b61e5dfa74d5e3653bd5ae966b82916b37d30cbbb821f9fd64ee954"
    sha256 cellar: :any_skip_relocation, big_sur:        "80564a317fc7b9450c421beb3b9f75117dbcce15f25ef6b9aa669f5a1973c929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80a9a73b074c512d79a492713d79bdc04066b4c25af356d9b24cd544dc47dfc1"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end