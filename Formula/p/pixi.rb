class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.54.2.tar.gz"
  sha256 "6a9c0d8b623ffa3e978d82e9db369d4ace0b850c12f5ecfc1117025a4e720df5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "062dda1ce5fb1d599b3816cbc1014b0c100b9829a4017419e2fed5988c3aca64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0df3d98fca44459c95aee568a43a9f670a2217f7a1b95e230f6ff6e07633f04e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b23d4f662e4e803fc821dd4eda02afe1b225bf1450396207db18747bd5c5af2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6d6979427346403fed3adbcd43fa7108f04c0c38310f0fa92a21b3364137367"
    sha256 cellar: :any_skip_relocation, ventura:       "2deb4696d44cf26a0442d4ffb8185cd887f39bc7aaf6b89066736c657d73bfab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b33adfc010159663fa5a474001481f81a95366d8be9e051e5668d1b64dd04a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db3a1c64704589b336932a9894c33edeb28d2c050e2b24b6ecec594ab9fd0874"
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