class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.0.tar.gz"
  sha256 "4a6588a52180b95ce0285f9469b096565edb79af689f5d2d9cc34f40a5162e82"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47696a7c42f70a7306d5e118e67edab804b62e0b5eb4ea62fa1756f37823de6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95c79d6e4c13b67f6b194c3c3945b07662fec3eca79b736882f8bc1be6c4ba28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe8f27593979762f0128eafe00db22625a7c72af5e8e8fcbbc7aa0682a6f72c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "dab32c2c10c6ee624859134dc5f196225d9e94b50e0232726a16041abb22dc37"
    sha256 cellar: :any_skip_relocation, ventura:        "5b646dbf09a9a4ef4515cf0682e4fec22cebe9fd79bc4c56e0f6bf58e94457c6"
    sha256 cellar: :any_skip_relocation, monterey:       "761fc4fe6852bc45af0ca0096e8c857b8d6351ca98d881612deec5f2d93be35d"
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