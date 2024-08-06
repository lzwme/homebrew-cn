class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.4.tar.gz"
  sha256 "2f7106f2e4bb50ad3f7d01ff368ddcd1c33a3495639961962a027f1fa5133a90"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88a7075ad3a570f05898c1310bfa798ba833ba6f0246ba9759c7601b2f73cb37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2527d9bb3388025947c58bb75f2b37a89c021a284f335c77fc94c8d4ec32e17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc13d61cbd27091c66a24a0862c545a2ae4911136931c693bdaf0a38e5bd5ba3"
    sha256 cellar: :any_skip_relocation, sonoma:         "321bb263d51d84d921c94260fb91c082a2acb011a0e3850f6e888b005154448a"
    sha256 cellar: :any_skip_relocation, ventura:        "0a755878031392eba6b652c40647803f87126bc01dd2f5211d9ab7488614c223"
    sha256 cellar: :any_skip_relocation, monterey:       "e90d69c93dcb7972d1aa8cdcde9810c7922e148200be2cb872c1b9f7114d8a16"
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