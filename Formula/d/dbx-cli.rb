class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.59.tar.gz"
  sha256 "2f5f34d0d9534886db314a97d4344dfdf22a3a80391128dc0157e8f12f4d4034"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85349901f45e1852ae16e6f421e65fc8aa75c9f65dcd39e8f024ea6506ec036c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d02d50e62a69efa861496a6b0dea6c0de47315eb50f90743d0e51c985a7a7e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cb58a7caff52e18ac43dd1c4204736560280706a8274537df01aece63291895"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dafac402a9f25aa2ae18ccce4395d44b326cdb213ac057a4e0c54d14e676dc2"
    sha256 cellar: :any,                 arm64_linux:   "0eb999467fa3c9b2bd12748568d3d9f7ad9e593add4e2fc354d9a44ee7ef92d2"
    sha256 cellar: :any,                 x86_64_linux:  "d789548ef433b26911a7068cafc9f1b2dc6073806a58eb507f3a77b73241ed90"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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