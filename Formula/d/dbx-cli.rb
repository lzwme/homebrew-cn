class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.84.tar.gz"
  sha256 "3af5ef129a2815d7de3b2afd0461b249d30cacad449719f8fc46f0f17b55a495"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f2cc798cc5613627889a9b6fcff0a51f0cff0cea1f3283e7af808c7e7e9543cc"
    sha256 cellar: :any, arm64_sequoia: "0f0892937873bf39554e04801e1caaad008754ee1e0ccb5cf26406f5d85dded1"
    sha256 cellar: :any, arm64_sonoma:  "ae20e9d4fcae860fbe8d6d72f42214b4b29b28108f6f4da882fdb3040eaf0ecd"
    sha256 cellar: :any, arm64_linux:   "a703ef1fabe46ee4ae56b3d7d92fc3865c08991b93dac9099c2d437c632c903a"
    sha256 cellar: :any, x86_64_linux:  "452b7f9f55dc629d1d8e7fc7923c256c20e72dacafa1e2df4663f43999ad7c38"
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