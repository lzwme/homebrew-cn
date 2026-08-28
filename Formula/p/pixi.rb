class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.78.0.tar.gz"
  sha256 "c30af3388faa0dd8b04510a9c5c47db4b7c6d34ed60ec625230814ceeb3f7ca0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3d7ade9226e5c6628dfd8c18ab3fbd75555d8c6d8cfd62d95a78f7f34b2e46d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1486dcdacf1d52e6914a0059b30488de68ae7c596558729103747b90b6018d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a95d696edfd7c064ea9ef669d09f906147dc5de8dc55f39b81bc5f75063a11c"
    sha256 cellar: :any,                 arm64_linux:   "e15edb3bef2469a42c991efe60b2900335bd3626d6e10dfa4c39fe27305e97e8"
    sha256 cellar: :any,                 x86_64_linux:  "e1d4457f9e141014b711010af8a55dcd42af826bd7dd7a348124486aa1bccf1e"
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