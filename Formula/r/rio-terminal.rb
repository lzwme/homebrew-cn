class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "ebd25d15015988b14d920e5d50e2336e4a9a175ee36612609f76b3096dfbbc15"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "242ef37adf89abeefd7313420783c6952c8a80a0ce6eb3b82edd8213fba2ed77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45286d7c72d70f7368688bf926b72daee6dd73b78a07bffa1f40aca77a092772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2864bf5c73b76447358cadaffbbb0aa11be2a04c719a730ed1e03672ab7593a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e59787c6f4b961a882243a6f11cc5e5668fa688299ff1ad673e0ee45c574dce4"
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