class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.76.2.tar.gz"
  sha256 "09c0a8b9b7fdadab7b38bb6190d1e72b061a565c03e16177e2053197de4df607"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c166a04f69130abfbbee63ff269e06e9941a5db7ed720d4331ffcb111c5a347"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a10bc50a9a7982f0cb8e3b7dad08bb4d01ef4a6e5f6a69679a9aa4d41b9482b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa05413ebac04ff75df6516bedd9efc071069ac334c90365b013e4f3c9712e42"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a0ab73d1933190681d54b3d09a121b2db21114e02644f2d25bfb154360402ab"
    sha256 cellar: :any,                 arm64_linux:   "ae01e92f5d5c2023ebd6feca13ee0ebaf8f8b34fdeed0467fd8a0f16fb185449"
    sha256 cellar: :any,                 x86_64_linux:  "347f780210ab6eb09dcab5432e739e267ad8c4495992001de4a9a69c199409a9"
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