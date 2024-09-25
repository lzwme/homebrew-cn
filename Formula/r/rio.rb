class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.16.tar.gz"
  sha256 "5311753404c4475751a514305e4dbb75c565f386e5ccf66d8238f135c1cd786f"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b37b5f130b35420b220b8ea725c66ad0396cfd8a258c1249ca19447ab2ade3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1751153b4c75dfb129123adfc51656b32f4795d73ec7fb946e1585a31b7fc7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a29dc48e8c5f53307602f1dc24bea87a54c1eacc1689bc566d64e874679cc1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf06a74ee47a53a195b4ecda17af3a45ea7eae876fa13280c2c0b7c389b18878"
    sha256 cellar: :any_skip_relocation, ventura:       "82d609f172ebd47de6ca149fc1de67690c6c93242929246a36e95a6d6005112a"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontendsrioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin"rio", "-e", "touch", testpath"testfile"
    assert_predicate testpath"testfile", :exist?
  end
end