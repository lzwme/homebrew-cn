class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.55.tar.gz"
  sha256 "7a1728136b9168ad3ac99f211219dea18dc5818f51b9c18eaf07ab638506727f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bcc20ae81792b6c5622496bc5c16c8c7d2e0a12104d24438fd01796f3f33731"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54280e4112d21899758d41d0c2c341e8685bfca81bfbe1bc0a4bbc4a2af687e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad254127f8c119bea46f6584f3a62e3e123184f52cbdb563ab18cc0279da0f77"
    sha256 cellar: :any_skip_relocation, sonoma:        "9809603a378f02201c08e2fa55058e30b15aa14f7b0cd6c4138328e271aeada3"
    sha256 cellar: :any,                 arm64_linux:   "f908929e5e35375c281341ef39418b4d78942b3f246b5659c34ca2c88e36ec68"
    sha256 cellar: :any,                 x86_64_linux:  "ce8d4eeeac410a6cf0e363419527751ba0eef933fe40ecb537bc1e36180d6ac0"
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