class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.3.tar.gz"
  sha256 "4cf5b35627003f369fd801a8bd556d708ebe9f89b9a45d25fd0408ad87db1bfa"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8b7d2105d336e9db53b787dc6869fe5daf800924655c1189fcbf9db801d5126"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd09fa6736ddb03202414d539b79a60a7e048c752bd990759644ca6d71b4ff8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f42dbcc3657bfdde99454a7ab8ce3fb400c54a47b4d6d35c7448e7f85122260a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b247a124c14ef452d52a13f915d9676ab00720d44b8e3c373872ee7dd0ce76a2"
    sha256 cellar: :any_skip_relocation, ventura:        "5f9dc4bedb061338d5b7f51c5d65aad3559b03959550f31c2e9210a996611979"
    sha256 cellar: :any_skip_relocation, monterey:       "affea0efb08474ca40524d19a5fa92e61245ab8a99abb2039112da796a9b8207"
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