class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.71.2.tar.gz"
  sha256 "d01e4e213c9eaf9ef8d27d5606022d4dad25a4820794bfb4aee8a360a51feaf5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a116696f87bdc3c105f342d5f631805288fc3548f71b0680441418651e1df334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f636c4f339f2b465485a99c224bff552bcbf135493dea824ff18b6affb72e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f10241ee1bdda15e70ba1d03df0825ca77d085e4f194cc8dff7d57c19ed8989"
    sha256 cellar: :any_skip_relocation, sonoma:        "294b7f2b43226d21bb8f8081cb4559918cfe9a3b9c0a547ef935b6490d72f3c9"
    sha256 cellar: :any,                 arm64_linux:   "9985f4d91d4e4a8403a8d2a717f72b9f2025fa5fc114160f8fcbc861471e65e1"
    sha256 cellar: :any,                 x86_64_linux:  "0a5ca78d7c184a550fa0d35ed2a497226b196328a3cd222e5dc04d8c119c527a"
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