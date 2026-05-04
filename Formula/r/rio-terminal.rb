class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "129b6ee4bea549175c25b901d2afbfa9292abfb48a4b9155d450a57d1061f921"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e87d283087a6ebed5fdaf7409fe82f9ce6597d1af57ece6c7ab89542eb56599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb8c42e8b3748e31560b295206e87683074bb6ee3c4a6ace2af5b9f97879727b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2259e0ad71c5a7c12915910b62e2944801e84f68786a6f3653828a73dbed7cc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "517ae8b0579c775cd4f863ac5314af69866cd8809d064c3b2f4ce00772cba1e7"
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
    assert_path_exists testpath/"rio.toml"
  end
end