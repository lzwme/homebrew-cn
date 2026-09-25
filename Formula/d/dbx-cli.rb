class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.96.tar.gz"
  sha256 "869e400487287297cd4efcb672f7d22bf6e333e6e906902a41981b9c1a71f41f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b5957f1d33fbdf420dc497d463a6df4ddf5e01ec4f9e04d6ba2b14e55af477f9"
    sha256 cellar: :any, arm64_tahoe:       "b9291337fbd13d9c41a3713e10a1b40f012fd6ebb13d368293a9ab4a4d581e1f"
    sha256 cellar: :any, arm64_sequoia:     "66d8729ba4e4d7b4fd6d7d8993793eaf9358bb208866baabe68faf424382b7ab"
    sha256 cellar: :any, arm64_linux:       "dbb3f91879e2f5be1ca0b7398d74c18c298be116851628fb3decee097b0ab1ea"
    sha256 cellar: :any, x86_64_linux:      "cdd650f3dd375099fbf0f878fe48dd68e8519201dab68fd4659eaa81078bd997"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end