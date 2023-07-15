class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghproxy.com/https://github.com/apollographql/rover/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "45d8b64082baf810f94b728773bdfefc20ff626fc244bc27c6edb6a80b63caba"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a586b283256a7679446f7e418d3dbc2f046d405f5caf37cee8f34b06fb70a57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d73e4d705cfd938506c4687a360aa4bdff350a084733f01a3163767beca2eacb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e8f3d34032d5ee7174a576d414c8dd724a7afb3d0653413ebf510577a5ab703"
    sha256 cellar: :any_skip_relocation, ventura:        "5d5e4f439be6f8839a18d8160c1ef6229ad4565b797553bb4ad20928796a12e7"
    sha256 cellar: :any_skip_relocation, monterey:       "e4facc15edd0b1c7a9693925726a1246899a4a3ac16840e08d9dd78adf64efc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "50eb93c0763e80dccdecc8b84a1709719d9c818132cfbbea77ac4d9a3d79af02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5150a565adebae3be281b6331d21ffe24134eb23f317e5870b13e7c15097506b"
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