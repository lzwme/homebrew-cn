class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.66.tar.gz"
  sha256 "c2cf88a1b63a52349b94af3b3e65283421f52b319149ebf3967b98bc88de452f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2423681ecf5ded22b5bd97b23004c7eceff66c31cbb5129816c8def37b7c6861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45913019edb6841d2dbd6c2d31a545d537fcbab15e796673308fe4017111ac16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4de987557055be91e485cacaadafffabb463c6ab784e2b552ea9e478c5436fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e04b36eb22a36059ecccce10ed3d1cf8c65892f658f8b5c559004cdf4abb6bdb"
    sha256 cellar: :any,                 arm64_linux:   "4fc2c7c727049c31f53a78bd80c50c08bc6fc74485cf6e64ccee63224a79dffd"
    sha256 cellar: :any,                 x86_64_linux:  "8e9b84a8343da74d6d0f2975d4643c4bf99ba5dfe7abbba5441bae500e09b8e8"
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