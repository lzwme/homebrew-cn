class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.57.tar.gz"
  sha256 "7228770425f58cdfc6bc395624733a1abf7c40623353f6623961f672c398684e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff013c886babc93284d524877900a3abdcfc5ba6f19f8b2143d8b3817e7d0a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "724edb19946dc41f75d6b5afe39d63cdd85df640ce6e30e8cb3695990b993570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e2d2fa8d01962606ce801f48d2a820a1413f55e42157799053a131272e460a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bde7bde688c57b675ae9c5c28dc5bb19261f0b697bccd8e56727417c1a36ffd"
    sha256 cellar: :any,                 arm64_linux:   "0d133191846b6087f518f2cbe9afe45feabe7293609f1205165cee9a492fc44e"
    sha256 cellar: :any,                 x86_64_linux:  "d1022665b0a1acec0876ca1bbed5ac21c9cc4d35159e0efb0edf168242dd9323"
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