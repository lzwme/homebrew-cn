class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "854448c9736366c32103536bc9220543a65bdae6850ab9250fb39a9fb0897160"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9df92809764b705ff1fe4938a97b1060e747fafce15c448fa6095c378c3d3f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbafc1c8cd85adec9fb71d850ece4c90bcb7b8ed0e6500b42ee43eb9f523e82f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7105ca022db80e84b32f9ea22d2de34d81486edaa192bca0827bfaa05f90df15"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4572b3315802379b8c5d99227fedfb4785a1b3a16c60c87fbd6d75045c33dff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae3fa2e535b0346fea7bc9a7700a3adb1dcc94bc1223f7cf5e52d2f1fdcd73a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f8532b4eb12e9737a2f16f20b8d3d5a4275cdd8bd586db94704d9074a5fa48"
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