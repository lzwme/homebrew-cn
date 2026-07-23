class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.41.tar.gz"
  sha256 "3f97a9ffe6aab57d638ffc953e9b165a2fa091419d9022c942fb22fd54dd95bb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0ef49c186c8a4ebf0945e0d8045b01718594f5d2e77b09cb04bfd4772885b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc36715859e0e90f9f5c73c79a1b05b4fc4a1ad6cf5acbcf52b865b6135400fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d5783ec94f727b88e14d4c981e6edc5ea565009872ca6485d2f9b85e90ad799"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bba4a605323e0d5d955a75df130c5b537bf36d9f412a65dafbd49740577c872"
    sha256 cellar: :any,                 arm64_linux:   "1434f11165c25436210976ac9209d9710c34b47a0a0632e4a83889128536a7b4"
    sha256 cellar: :any,                 x86_64_linux:  "5c4f9e4ee0d557e75225c2aea318fcd53935db44f212864b13187b6b2fdd125f"
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