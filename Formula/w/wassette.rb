class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://github.com/microsoft/wassette"
  url "https://ghfast.top/https://github.com/microsoft/wassette/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "552e5a31431abf37a7476ad343bbfc194d81b5b421dec1546345cdcc09fb5faa"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3453f658e82db85c13e56a6a3c424270f229d1eef0ca427a94798f49ab4439f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0dfa98b471573e777ee918611b489b689fa101f9a607020a0d3629ca726d19a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b5a2ce1eb7ac4ce63f6998be348414a2dd76255fd764172d3495ffb7bea236b"
    sha256 cellar: :any_skip_relocation, sonoma:        "82f9753113c7604c0938ed56ad1d655bd02c4152ede8f12c6c7a69a141f583d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00021b3e647beafe909db6ea81f7abbb68e93888c9de24f5fde5f7c3b7637b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf3344168e0d17a624b4307ca548934bca9866991d880ba171a1fbce532206fe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end