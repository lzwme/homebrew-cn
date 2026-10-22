class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.82.1.tar.gz"
  sha256 "1ce72cd1f93f336ecd767d8aed94ee0662248de8cb973fdbac8377214ea021d7"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c069f3ea682c6ef391a5165411a08d0208fafb0f237c9a1681f3d7b48c8fa7a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89eb1b18c8841f80346cc2e0e726c37be5f8992a0b360a9ed0b2de666d798d3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d049b41fbf13dca2166959bee645297fbb729f596236fe79d706ad5706f0c310"
    sha256 cellar: :any,                 arm64_linux:       "5815ce3fccc9c4ab54f21d5c1b401f6aada24718d5d6b14d1f3c5e15981565ff"
    sha256 cellar: :any,                 x86_64_linux:      "65dd41ebe303f252a7021d00c0d8ee4d3257e3569d757b00ce56a8a5e1625fe8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz" # for liblzma
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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