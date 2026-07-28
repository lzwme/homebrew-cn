class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "8a985719341dead9e0d3b0b710e94053c1b5ae8751d79829e0ecf18d1dd8d743"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c002440ad1de724d1dfe3fd59ef85ef54a5d9c493362970a7cc6efd7b10a4d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e085632b75d25fb82e9699100975b3e461156d8eed8aff11e3e275baf50db6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bfe8902cddfe99ec3e7c02f8bd349afe682f559f6d6cafc7e1e5e4f64e3b407"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bc9e317f82857256cd89b2e90257fb81edcaa6054b7f81856d737b4b3d50405"
    sha256 cellar: :any,                 arm64_linux:   "9a1c9ae5feccf6250c335cf3db5901682b2d9202d422cdbbde21c032dbdf099b"
    sha256 cellar: :any,                 x86_64_linux:  "7f0588c1725bba0080375c3b961b5692b39d3d7f915f023ca690c348b4914b2e"
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