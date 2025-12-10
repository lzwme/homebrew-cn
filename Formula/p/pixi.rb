class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "1e686cddd8876ea8e8e5722743da2658dae9742570ad121f13897553050ac248"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50daaa50b843c3dd4a40b08575492187276ad7490d380ff2aa17024dddfabaae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e2ffdde7795b3e1f53cda90236c7ddebaddde026e7263416871dfd3547b5ac5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdffa368b9ff90db700cc0d76a91f277acab118baff9ac3356c3a1f440ebcd98"
    sha256 cellar: :any_skip_relocation, sonoma:        "59b56a0a19d44b11e67ade39ea6426cbcf909e0d49031f4d80140992467ea22f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea18a538597ae4a5bb6bbfacbb15fae764b7b008d41c8dcd1376e5ee271dbeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb6aad3925dd26b2937f4da6e5d17de6bfbbbc9aa66fdf6a0d2e23c1d59d2f6"
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