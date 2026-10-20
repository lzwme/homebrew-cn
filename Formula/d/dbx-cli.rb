class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.125.tar.gz"
  sha256 "65f64575f9b71770bc098757a4ee642705c32324c41034f418ba6207b8c5b8ad"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c6545f2eb026cd41797c0243835cce0b22421a0d48d5c1893bdeb590d24df3c1"
    sha256 cellar: :any, arm64_tahoe:       "4c74bad416a7ee731cf5b2e736bcd17b732ed75b5501c48d4cb5c93cac78c129"
    sha256 cellar: :any, arm64_sequoia:     "ecfb5b620e9981820739842c1354731e21e7b5f08082e342e53e1b3131ad84ae"
    sha256 cellar: :any, arm64_linux:       "27c42832546538e177c59b4444bc90331915f690af28a26562921564121f3344"
    sha256 cellar: :any, x86_64_linux:      "762485f8e11a8a16d334f62d2735c311a091544ae5f98d7ead01e92c9ea1a639"
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