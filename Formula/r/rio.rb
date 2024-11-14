class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.2.0.tar.gz"
  sha256 "605ca1e5094119337223378e477236e7de7d4110473aefb7e51396dbd0e89a4c"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42b35463b91ebb8af8b10bf267bb9fd248591cb549b5b171dae4212501dce86f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d0b80676ddf337774edbff6ff025bc939a115c979c14f2e4a898d06bd6cf357"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a36b69bd77816c356f60cda10422c186d2f10771d16e1a267dc12b1f2c58497d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc84c6ff1b09adc4b7338800f55e4fe01d15d34447d41171aa26ef810dfe1f2c"
    sha256 cellar: :any_skip_relocation, ventura:       "e5d3ba93869435181556dca139b9b22bc501793e0caaf324769124c219946b37"
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