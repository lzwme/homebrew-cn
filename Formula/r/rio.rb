class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.2.9.tar.gz"
  sha256 "37a0894ce76180bd5d6866c7aaecf30cccfb1518867790cdba827d0c9ec66ec2"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4544d6f935df4e4eece2d91eba5ddbe99ee9c109cddd6bbe8eea90d5a9182078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf1a84933a3cac885ca0981da273170d9fa296cce48834201bf8a40fadf38fe1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eea5bed9407a1fd9641eb101473a166f0d145bb74333bfce746b9a372df18b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8065ca1500ab95cd751ab56d618e68e25b4689ff18d41d82c64400569d52855a"
    sha256 cellar: :any_skip_relocation, ventura:       "636dbd413605ebdc3038698c59217e75f76335d4775543e2b66706340fb7a96c"
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
    assert_path_exists testpath"testfile"
  end
end