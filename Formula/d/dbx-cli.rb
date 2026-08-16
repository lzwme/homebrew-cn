class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.63.tar.gz"
  sha256 "e91feac5e4adb31ce31abc65fec103b94a09d443d5bad4b09795b58ca0439fd7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cab755a9762d397d9ad0b7dca02ab18f561b4dc09bb15a6a821a1a745b834b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e17cb5fa2ad307595938e94f35429fe536e9615797d0decd558f639cf25e4f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4ca9747a7451cda8d76dd4421898d56bfb776cf75865d57b5811c9ad5d8b8ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b3c3aca21b1e099d463205245f622564371e90b0f21c1691c9d6389702afb54"
    sha256 cellar: :any,                 arm64_linux:   "1e278c0a3c9eb899ac2dcf7aa4d319bd38953ff1d1628ad32b6ae6a67135a02e"
    sha256 cellar: :any,                 x86_64_linux:  "0afff30a4ff5f4d12b507ace6c007929e7acf067d3052754ae8c67e8a773d8c0"
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