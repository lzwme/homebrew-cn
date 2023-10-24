class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghproxy.com/https://github.com/apollographql/rover/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "90173dab3d3076fbab85d00f7edb7a169e41267f7c52c47526d3c766a21a077d"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec1cb5f519cfe99c554626417959351e7bbfb205b2c59c671f3a7757c97e40fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e0ae4bb93bb376d9fdaf98674bd0cf09180374e2d54a49fd5cc075907dd7089"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12abb21f28fcda8293506f2939a35e09d6633e045689450609ff4b173b8428a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f28358feee7d0c1753c8a1e7341028467fcc56930357894cb87d834201781e2b"
    sha256 cellar: :any_skip_relocation, ventura:        "aedf38a075b6b079a58afa371416719ab0413277e97002aef4ee08c956c390fa"
    sha256 cellar: :any_skip_relocation, monterey:       "56b7587bf3a553f0a09c1c2327ba9c1a02695767650c1978b6c1e108ef22fad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4686982783b19ff4a99dcbbb240670bf0f5c014086762d3cd8754d60f37b0432"
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