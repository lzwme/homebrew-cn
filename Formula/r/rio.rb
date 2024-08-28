class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.10.tar.gz"
  sha256 "74a366d8c59d780843ed05a2fd10837d3e6795c4d73a90d600ed7637152b89a5"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93131f7c890f0bd60697f4e69e77cbd5d5dad245ec3ffb9444384f5930e3ce79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9817773f19b0dcfdfa415a7cbfde11849b34a611645a63f8156db5f1fa654c70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a59b4e075cb421a87595e46c2991b9ec28f6d864a1ccd5c4c5606baeee90c35"
    sha256 cellar: :any_skip_relocation, sonoma:         "e85ae682b2563dd2ff09d92697e28f1548952c8c4d0d547a3ea3d2a83fcfb082"
    sha256 cellar: :any_skip_relocation, ventura:        "3add2e393f9dcd23615778c6e24388a308b85ba277b57d2cca0c8daf10e10181"
    sha256 cellar: :any_skip_relocation, monterey:       "994e2b936f22c7ae7e6b62c5a937f2391de86ff9d3dcdd7d3b89147368d20579"
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