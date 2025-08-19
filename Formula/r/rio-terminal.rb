class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.29.tar.gz"
  sha256 "2f6568bafc80c3b171e70098037469d567512281ba6e5b6bca17f53849cbaf99"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b90acd15699488d882f24d1ee1f24665a3a31d5c87e6abfdfcb4037a9d3ad5e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66f43bbc225d7a8e8a6513a8e5bd97d0ddc0f6537060675da98161e57ff92a4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d03c70ede339f0a1f6fae2aa2495bf6c42f41afd086d42abfc1855e1a3aa7ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fc87bb0059b7accb23e4fa39e998c42e9f496c7db189c87b1eb8bde5b6123c1"
    sha256 cellar: :any_skip_relocation, ventura:       "8141447d33cdbe8ae9ab5ee49ea9e98ea0043daac31ce7b0768ea2acd915150a"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")

    system bin/"rio", "--write-config", testpath/"rio.toml"
    assert_match "enable-log-file = false", (testpath/"rio.toml").read
  end
end