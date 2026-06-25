class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "5ef1e13cfb7707528ca4759ecc4e4dfd63267ebdec0e189cba6447faf2ce1924"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab6db81f9879dc8b968856df64557eec0180a24311000d755d2eec6e3980e9ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6333f912476865cb42f8e52cb0dffbe806e5855a5406e485d369c61a5b667fd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0584aacddd2d04de267a869ad20a6e1e9402d93a6d5a2fbe90f17de2c0bbab45"
    sha256 cellar: :any_skip_relocation, sonoma:        "2558ff24403c6878b52a3a3f8687fc22b5690e3e97d60e55b5c29cd623a0ef8a"
    sha256 cellar: :any,                 arm64_linux:   "b5855f9044b7f656ecf12f6b3170498268f5a29671d20cc7b604db62f52274b5"
    sha256 cellar: :any,                 x86_64_linux:  "31b49eefb79f1ac3974034c3a301590b8f411c25f62139202d4d625203ecf14d"
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