class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.134.tar.gz"
  sha256 "ecc3c6e2c7e666e5042673427beecf007b4d7f9605e54ca0ad97d69acaa0438d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c8dff0eb1ead8e217cdffcaf4e3f8d24500341f6c0005d81ff4e74c68d52d149"
    sha256 cellar: :any, arm64_tahoe:       "c84ab73dd875c0681293ac95d0a9931ec45e3aa1dd67a42353db78fcb153ed46"
    sha256 cellar: :any, arm64_sequoia:     "5c73324b27999443099276fe423e122216ad51a7a818811ca9b4982bd9d5c36a"
    sha256 cellar: :any, arm64_linux:       "ef8fbd79950222f4e9092434d9c16787f303ef2124e5cda1049aa6fc86c6fca0"
    sha256 cellar: :any, x86_64_linux:      "3dac1b69b1a509a75b5e12fa41674ba7ed69f7bbd584948a26f4b103bfc2d603"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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