class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "cec59541228f1599fb69f94369bc8498a4d027040421ce277e850d4d0875b7e7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a9350bc7298cd3af4011c67b528819aa1d5adda14c3aca1da9c41b635ebb008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f9ebc5656daee6a89317f170f97e021e1503396b75d70a9414cd7e4d2e3de7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8c573bb4ea8b0cec30c7d9b694d68f7a66d6d9763dab9c46dd9a1179b8db33f"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f8828ba7fb1795a68f056bba42cfab0c7c272db3edc91ae4c22161bd655117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb4575ee1cfba0c0b43413c52ffda13a388bb1e5893c74866a0d59fd29115043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "019fec88f636b10208a55257cf7eaaaee7a6f8b156ef3bf13a5ced04ab5a7f95"
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