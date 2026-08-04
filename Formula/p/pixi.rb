class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "3f283312fba4777dbfb57f48db5f95300699fce9ffc30c84009b2f2c55ad56e5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de86f71ae4affb2adfbabcdaa705af8a22969be686bf9b17b0c5624285dc91f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f8380e0eb7d4ef77699d50d571f2279b2d876d71c4326ffb447cedcdfda0d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99305db88ee036c305c8f3486fc40a757133b387f84e525d01a1b0adf556bfbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4077b1b849dfb70c1b5f4a4eb7ed37066082bf88ed7bf6e5bb94d425082bc7"
    sha256 cellar: :any,                 arm64_linux:   "1d8ff815a1a133c95b50747ad1a8ef559b5613994fc1b3fdae397c2f75a7d0f5"
    sha256 cellar: :any,                 x86_64_linux:  "90b64e43dacc89cdb0ef16f9d5d428ec718e41232b0b68ffe05f263037c825df"
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