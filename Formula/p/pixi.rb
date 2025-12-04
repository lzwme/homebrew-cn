class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "a8db25102a5203d0175e0cee0144d8cd7c525bf6a8556ad90ad07c54361667d6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b991536d96e0b19d9df33eef3fd0ce71bbaaeda7c1d3ff955dbb90404af343b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc0fe4a3251e44aa6b07688e779d9585305b04ef627726c6f5d2529f8eda2f7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5feacf6e9c49ad6852eebc352e5b87622a12dd5995667f63de9b78f97939509"
    sha256 cellar: :any_skip_relocation, sonoma:        "9669b736a2a60dba3405c37bc65d23e38769b624b3d23daec8c466ef336717c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de7cb6767f5d2b51337a5e9737357ea5fc33bbdf7cc173668943106a1ef1e41f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1dbe62bb7942bfdbc7ec9ad72fe1ca59676a3a2ddc504f032c7521519fb90f"
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