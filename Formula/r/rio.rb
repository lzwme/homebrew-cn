class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.2.18.tar.gz"
  sha256 "ef0ce3a21210fbade1525e74d601f31439b2fb1d261e5456ca891ef80260ca57"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45dae5174b78a06140dd9759783d306096d33b0fb9801d4df803211df996df20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f30db34b1d5960435aff11cb7cabb4bc15dd33949374741d4151fc65b2ffd69a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b45f09c8102f125bf8d2f779a09aefb9644b139330b991e0f0b197c09e5d38ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a1959a5fa9e1b1fa12d417f7c317a45af9254c8f56932132c360857cb0f771a"
    sha256 cellar: :any_skip_relocation, ventura:       "8aed42c1c9aeb6713a63e0742ce849d54f5ef4fe479f74fd095db6799899a3cc"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontendsrioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin"rio", "-e", "touch", testpath"testfile"
    assert_path_exists testpath"testfile"
  end
end