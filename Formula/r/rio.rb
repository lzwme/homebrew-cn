class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.8.tar.gz"
  sha256 "529cae91869b2185986c3bff6db4233fdaf4242ebbc1fae20362c750510ffc04"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae5b47f97c3a3c0b958e5ebeb3ac77912a105da1f49dc3247d347c5d758a8a25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48b755fa2dadbb47e41b01a3b08983481933c11c81ecfadc4556775193d04cb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50e8bd2e5123bdb463d0997d206bbdbd41325795b85d8e28c3fde96268377478"
    sha256 cellar: :any_skip_relocation, sonoma:         "e36d754f38382e125f837ded9a2f671c4c9a322e6f8f1862dd48f6cf1dcd01ca"
    sha256 cellar: :any_skip_relocation, ventura:        "00fb303e378d0257e577ba7c475edbbb37fd420ae7f8ae4097a898e8471dd0ae"
    sha256 cellar: :any_skip_relocation, monterey:       "eaca3f969f0e6a6a263cf5c93dd4441cac68594841f5646d2f30b8088fd8f24a"
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