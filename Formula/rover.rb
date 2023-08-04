class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghproxy.com/https://github.com/apollographql/rover/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "04756cfe56c67e9fe2b540feb25151994e6c0c527838878e0b884c9c12078529"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f33eaca6bc83be2cf57c8457ff110205e2abf5b5c7a392caa70e156f3a57fae7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bd9a1a6734bdc52ee992cb0064c31535c2c1efd677cfc07ee7f54ce893f4be1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a85794fe46fbcabf7477bcb4968b2e000529fdcaa3d46efadb5ffa7e7a51a42e"
    sha256 cellar: :any_skip_relocation, ventura:        "78596a5a5f25503e43a6476227c2f55fda6995aa647d0d940573e7c1dd8eb6df"
    sha256 cellar: :any_skip_relocation, monterey:       "00ce9343dd079cb2288e2d015adb64575ad1df16ef16e02668534c92c1c2924e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b54f8173554290efc9138be976d6cc7294748b3741624a30092e4e320e7099f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de0dd529a3bc7d3c4dee9ed4bfd1ed301575fd3759198ca4f68a9a2c654e2875"
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