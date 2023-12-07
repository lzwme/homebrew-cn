class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghproxy.com/https://github.com/raphamorim/rio/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "fea273df1f5e4b7aebd52cb619f9462a15be29093734220e68a9f4e0bd477adb"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c21e7cf1c4afe675d4af13b50d8aae0761f68bc1251da09df788f24c3fed8ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5da7e895c56169ea3ffe92444c28e5309dd0dadc19fdbed0ee8b55ad5dc51b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f7b2852a9b454f092b1dd68a4218ff8505bb280444fc788a7191b6debb5dddc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5790f51355d6dadb18bbe4d79f975bbca5c5255772ae39f7c6301e7dc9da5fd1"
    sha256 cellar: :any_skip_relocation, ventura:        "fd2c98389787f4c4960e13b26b33c7b9f8e0d03a23111ed31483be4836e9d9c7"
    sha256 cellar: :any_skip_relocation, monterey:       "b00ca684b3adc837fe51c474e7067fa8e24b5dc8227d97adb6ddf01f1730ccf7"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/cross-winit")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end