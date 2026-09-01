class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.76.tar.gz"
  sha256 "0f07b748028471cb08784f1e5c322eb6f095b313ac168cbbd441e7c004f65e83"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "90b4e9080402c181420087b6194ff1aba217594424e3a24a5efd63332294830f"
    sha256 cellar: :any, arm64_sequoia: "d4d3935fe7e70f0a34c39edcbd186b6f97b539fb6d1ce2353f90288102e3fc49"
    sha256 cellar: :any, arm64_sonoma:  "0056ae2a29b85f0b373ea1b19985fe78224922d2cdd16a040f0ef8e559276871"
    sha256 cellar: :any, arm64_linux:   "992086751ecdd01fda1d8d8b73b97020654717ef1ba64bf323b1676f47307b91"
    sha256 cellar: :any, x86_64_linux:  "37485443e9042f339f0b342093723d1fe33734e4d5e0c5131579efd559590182"
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