class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.2.19.tar.gz"
  sha256 "813dabd9ac7760e17408163fa4259ec9bc8e2017fffd140b37c18bdd677318fe"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d727079d95cdd8f8fb0df61ab63f8c06288e1d42297507006d373bf94cd3b22e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "376c9a9e3bedffdf15129c57554e54d02dc8062a4017242c2cfd80a2ba95c2f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6618584881f637ad1e5373ce1e357c448a8078c34a96f270e2f65e5702156193"
    sha256 cellar: :any_skip_relocation, sonoma:        "27782152198224e60aab25379ee05bb30e27fe2a0a513da081c6729a41fa0c11"
    sha256 cellar: :any_skip_relocation, ventura:       "cbd3eb688ec0fc18131ad39f850dc7e2a2b80b5b5a431979331dadcf0fd8656d"
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