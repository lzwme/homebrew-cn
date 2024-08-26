class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.9.tar.gz"
  sha256 "2251257f42a8bedaec1cb3e4253afb2d2010d7bdf3e36bef22cf4344fe4ed285"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a043eff289334797a50ef4898b534e62f42f076ad3d6cb63904b1d5c9c57a609"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b96c0d1129c18e0bd18c78a4f799571dcd28582bd7034bfe35146b85a09bc890"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a933ceb15c1bdeeaf95f91a489d4d9501aeb31590424ce37b2b11466f58cd03"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e46320b011ca40086eca3f22b3ba2e556d1c5de4410cdbe8395841048c9048d"
    sha256 cellar: :any_skip_relocation, ventura:        "bc1dcf51576cc27d70be2fdaec74138f9daba2ebe6db6e9b9254b447b470e6a0"
    sha256 cellar: :any_skip_relocation, monterey:       "13ca4febd119d0528eafffb31a816f657e3a73037f1c494012282a4d1c4fc057"
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