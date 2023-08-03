class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghproxy.com/https://github.com/raphamorim/rio/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "54d52ecce753b7667f817080d2e6a60bece71c111169c53c674699c871323378"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4867325c53c0a27ab8a1e739caaf2bf8cd79a350c83c01549a58a887d9fbe9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdf060a0eda6bcb0d23b4d3eef53c3af6a1b72be8193f9f4505f3dbfae46ead7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "affcd1126847ccd59610fc678ebee33be8c4abfb0ea947e0f43da9499c44e7c5"
    sha256 cellar: :any_skip_relocation, ventura:        "6cdbf188a7b5e938763a044de32281e91b5fc90518b588f65d31b34919f00926"
    sha256 cellar: :any_skip_relocation, monterey:       "244bc3dc32e39fc5457fe514aae24d583a33648ef3eb790202898479dc2633c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "20cf974c3a6a854f429faa2b391bfb6a9eb58d67e792d6b1aecbfc09836b6701"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "rio")
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