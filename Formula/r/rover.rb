class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghfast.top/https://github.com/apollographql/rover/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "14063a8a2c7885bf84d7ff79dad4cf113d8aa1639aebbfe2c56c7f46d1191686"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "405761c0d7b55ed03c10085eb5e5b0736a7893cbaccfdc4b1ed7f6301c0f56c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe154d148780d8d6ae67964d6c2f70c511f9ec53960d939be33e5f23a6371a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "289ae801078c0ccddda7d770d894c1c9c05425c95d88b85028d1bf9742c7d590"
    sha256 cellar: :any_skip_relocation, sonoma:        "d97c0ef57b8e4e799ae1b4c0b2f5f85c545c9da62d91df3258ff1229ccd80067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a9ccea782f28cb5e3c5399508752028c288014e4e6d0983ec90125ddc84ee13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d0f745e4ab9fea139b83ffc227b4a825535832662b32d9f2ac94ed02a651e6"
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