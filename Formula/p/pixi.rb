class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "b0e9e514386079bc6f30e32d9f51b407fb332b1929a78bfbe2fe0bd8866792ee"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dde808df3b762fa49896ddf7e89c777b0003b8d012fbd187fe7081a059bc3bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a6171ed435e7d45d1b8c4243fb6bb2d3048b322397a947523176271660bc7dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c7fa559fd5aa20d339ccf1e7f068402a0997871b7ac4ed0c320e50dff5f71cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfffff530df0fa7f8a1ae580c8fcba5534abf9b34d795eb6d1539ec9b911eea2"
    sha256 cellar: :any_skip_relocation, ventura:       "87e60cc012facf9f9cd1c3d3ad4fff5714f8941c25623121bb63c64b8521fb2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9499b048a1e279705a421847e1392e315e5a9aeff2bb67a95f19208dc0c662d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aca2db9268920ecc42296608625363600d58519fa8cd5152b8035fbb3b7c92c7"
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
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end