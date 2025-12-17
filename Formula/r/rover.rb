class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghfast.top/https://github.com/apollographql/rover/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "6bdf352d9a92ce2fb2e89296afd8ed4dcc91840371deeab05da256e0324d0b7b"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28b0836a3579d1597ebecb8d7dbb7ea5987862a028a69f11a464b2be6e2ada62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16d02424a802cb8c67f51dc5d59b55178dc253f8e3e22cd94c574a887da06341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b68e4100d933f55d0216e2258c0fea74e9d0aef1e5d942636b546ede65c8aa9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c9756dd069a51bdc4af7a96db00a804a3b6d4b176c3ebc2601dd65cd423ca87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66633fa484c0a5824e7bba91412ba419577fdf2f96f24637c03631b081da0282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a21bf2293f0c2ce14073f1e0ddc0295cf7e1a2c9223b22d05d041b15f1c0fc"
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