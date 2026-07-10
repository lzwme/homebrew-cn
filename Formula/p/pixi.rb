class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.72.2.tar.gz"
  sha256 "7405715b9492f0ad4c8aedc60d6df4dbe71b05db006de5c3026700ae2ed937d7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3571fdc732301c552e16ac014b791974f224c35a712e96f9471525cc556a57e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "479deb6ad21d5356f05a5c7c5b55a951af9b6701eb93fc3f18a860ff426c0eca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbcb1849a73836b950d1aca64a34ef0a3afacd4e1152cda32ecdf664cc47024d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9821178d392341901d9488f6d8380621322d7b743e70e9ce22ea2e5b07b89e1a"
    sha256 cellar: :any,                 arm64_linux:   "72ab8cd349792c7eed2fc497ea6a1783ae2fa82a97416e458b4fb2e013141890"
    sha256 cellar: :any,                 x86_64_linux:  "b91a7964ae07056f35ebdbe822fc69544ae63b56e00768b78e74a2f87ad58443"
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