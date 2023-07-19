class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghproxy.com/https://github.com/apollographql/rover/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "c1a81673b1b3d763619d8b86612fe0cde1a9c9f063692e35eaeb1ad520958e18"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a565243a0ca7b47e61a36132675afd147c003c5d08f33a5cd6d98163268001b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ee28bf82b9d31357191350b11d0f95f0a8c0041e7633df1b5c2ec2b095ffaf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21d95d1cfb911a0fc6cef577f98d226cd8f5c5b45f1101bd58d20ede08428e0d"
    sha256 cellar: :any_skip_relocation, ventura:        "31a9c1765052437e4bc5ab5454b4f755ccdc048dcd2512b9f96caa7003e008b3"
    sha256 cellar: :any_skip_relocation, monterey:       "21c924ba9046653018289518a10b4bcfc963037fb7b8d00f0e0ffebc733f8c01"
    sha256 cellar: :any_skip_relocation, big_sur:        "a11d16b0df43e86c085ba7bc187fd26f09b5337762fc4cdbfd949c8af8ae1e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14231654e3cc36fdb6f0b6488b0ccdd611b41a5446ddc7f8695dfec8bc7b9e28"
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