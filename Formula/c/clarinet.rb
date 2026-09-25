class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.24.1.tar.gz"
  sha256 "5f5792d2d735c8072689001d4b1a597dac4957695331fda8349ca472327721c3"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9503b663e5e8a4b0ff6b001954e7a28ab569e460b8352a246b9f13705c7fc001"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3b5f0b7f40312de39d66f0dd9f07217784e91349d181768a5f179247fca4b886"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f7bea49c99224a3bd42377e9fa6d5854f4f931bda76958a825e72be1f759c3c0"
    sha256 cellar: :any,                 arm64_linux:       "75466b9597206984245e8df58ab01349499e6fed5b8cba63aea082919e9f9c7e"
    sha256 cellar: :any,                 x86_64_linux:      "d06f1fb10b92b4ae67b0f3c484ac462109cc046f0822a2a04d85dce1b442ac8c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end