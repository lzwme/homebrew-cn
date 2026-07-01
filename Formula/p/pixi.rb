class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.71.3.tar.gz"
  sha256 "fec3e9d839f4648c167ab0f1ca3ac677120bfa02debda5d646a3678a030432ac"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b92b283752af32b4b863002863fcb4ce36e458b482ecdc5c641bdc4f5959210"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50af94dde478c1ed10e87da62373eb9d5ff937a686bb3bcebe7961ba153674b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1856267e85a20094872f76318b78a2613123d88daedf03a63b8936cf8fca6f94"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a28a4a445f108bf14bab4f90ecef3527f9d21ab98e94546e230e1dae9567b65"
    sha256 cellar: :any,                 arm64_linux:   "65b560c8db535ff159a311f6564ef272b4ebd3e5764276314af35b6349cf15f0"
    sha256 cellar: :any,                 x86_64_linux:  "28f24164d12b8563a08958f7bcf32ad6bdaff69d0c7f254fe433f6d0729dae0e"
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