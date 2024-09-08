class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.12.tar.gz"
  sha256 "7fe4a0e462e8a474cbcf7da4085dfe3d72ed2bb1fb801a851447a72d0c62be7e"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30ad316808c546e62494bdc3fca2a4ae4852c643e6b57dab7f87c783b6c39b6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd2700ec5830ecb1374dd2458456daf0237dda51a22a274303d8ccf3b20ad080"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd281f873ffa19f777a545903d41e1cbf44974ab6fb8f00b58b9ebdaa5b6e799"
    sha256 cellar: :any_skip_relocation, sonoma:         "47fc18a9986eea5b1579956b8f705a1839da72a4afabce185a67a02d10a861a8"
    sha256 cellar: :any_skip_relocation, ventura:        "aabcabdbffedebdce963b14de83465cb2223db17870cd4989a0546a5d8356540"
    sha256 cellar: :any_skip_relocation, monterey:       "4921e8e0b6c55c5c5eb24bc2da373fb8531e95d54f00c5bee16c1d812844d531"
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