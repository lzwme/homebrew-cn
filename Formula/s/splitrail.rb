class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://ghfast.top/https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "58c4afd633b57055f0cdc2a4f81788a8245558c2127e5f58194d841f2dbbe1dd"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16c865841be15b7dcefeecc52d84555b4ea5eb5fe0d17446180497cb16819fbe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de62e66599e6feed8d603808c7d26625f842f69cc08b758ef2065eb9c674e184"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "896157f9127bcc57025626fe7951a08bc9e596cb3f3ecfccb99322079aeb1bdc"
    sha256 cellar: :any,                 arm64_linux:       "b8bd00531f0b2cbfad7213bb25f628a2c1fd527342f06c7bc6c14fd920489186"
    sha256 cellar: :any,                 x86_64_linux:      "533a377812749a7faac71ca76489d786ddfb9f4d1e78ca299ff7b384db763d26"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end