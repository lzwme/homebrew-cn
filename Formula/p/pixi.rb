class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.70.2.tar.gz"
  sha256 "bf584bcf2ab2cd538df34203df2c3dbaf78bb07838139a5a8aeb3646f87dfd30"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0f52ec6f508f4db3bd587db02d8546dd92e98a6f88590ae51eaa50eda47aae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b57d44f3009a1af90be08264cf66e002fe67cf40b28e73ec9c63f64b8b3d853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "819ff98295ba46b0c16890f631c8cd0d04569693d219bc1d19844cc707b8a694"
    sha256 cellar: :any_skip_relocation, sonoma:        "240957dcf58d84d0d98e1208528ef1f9a7800f0707df08a9f7c857a5fe8dbbd9"
    sha256 cellar: :any,                 arm64_linux:   "0971265a68d39fcb85ce7fe7e1be46e8e26142a2bf5d2fa186899d5c8c16feea"
    sha256 cellar: :any,                 x86_64_linux:  "b1a68ef06a072715e9a73722960eb8ef337ef379c30100ae09eedfe308b114c9"
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