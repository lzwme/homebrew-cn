class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "b6247d725c8bd859b964a90389cf9e3a4bb01aedb69b002fdae1a305eca86434"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d8100d5ea6311ed7ded557727d2008634f43b487880fcbce306f6f77044b314"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3461e6f1c688ced89b8d9c19452341dfc99fa8f54aa852ccea6eb295f49d3377"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c914de9098b78604c14021862217d6801a02d933d76fdadd44d98580454e02c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f9d33cab516381024936902a63ca0a31df073218db43320d5135e6cb4bdc43d"
    sha256 cellar: :any,                 arm64_linux:   "5a03cee6c9d1edf380ff2578767456c74e2816a4565d568ac002a697339623f9"
    sha256 cellar: :any,                 x86_64_linux:  "59be0a858a7d1de349f701b540ddfc014787a34bb0d1bf1742d8a2f227ad9b9a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz" # for liblzma
  end

  def install
    ENV["PIXI_VERSION"] = Utils.safe_popen_read("git", "describe", "--tags").chomp.delete_prefix("v") if build.head?

    ENV["PIXI_SELF_UPDATE_DISABLED_MESSAGE"] = <<~EOS
      `self-update` has been disabled for this build.
      Run `brew upgrade pixi` instead.
    EOS
    system "cargo", "install", *std_cargo_args(path: "crates/pixi")

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    ENV["PIXI_HOME"] = testpath

    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end