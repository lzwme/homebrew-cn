class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghproxy.com/https://github.com/raphamorim/rio/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "fc8a89f056443d861119c168ddd0116a7d9b2a6c978aa3afdaa419a455956c7f"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef02282d103d7a8f286f1625563eb138fa63a9b032fae51340f6cbab11d02a27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3316c34c0b7341f00bcdcf514693edbb1be5ddab7827255d864cf36b88156e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "752b1e6c0de4ac46568430fde0e83586360a6fbd3233dd0967c441c5ed13eeaf"
    sha256 cellar: :any_skip_relocation, ventura:        "b26c1f96b6c3fd29cbfbc1fbae4cc103cbb6539be17133a354d21dc6bf45a1b9"
    sha256 cellar: :any_skip_relocation, monterey:       "959162b6a61971e7ceec9e15f3b4b107ec386006924ed6570cbaa8967a91727a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b0e15e6ff1113dd44d71657e418f278fedb391dd128eeb5594d2486fa510496"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "rio")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end