class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.80.0.tar.gz"
  sha256 "5f1c9096161d35772053268d89523a511e69a4d43270c145c9c5e91945751cbf"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "feb79e6e4b21688214f8572492d0363ff0f60f2600acafc67c118fd484453f30"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4591af1f0ae313004e55fb089761c1b6f31bacf7857c3c1d657d68295a87872d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "890288dae4cab5495dfc01e898614864a7f14b5d30d16b2e654d4c522113b72b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "19fcead1ec9e15b3928018b785f58488729b845349a69bb825e7531297614dcf"
    sha256 cellar: :any,                 arm64_linux:       "7fec984032c75d122607da48ed6968ed3e6951d68c60c12590014a154e8b5f6e"
    sha256 cellar: :any,                 x86_64_linux:      "a3e2eb0a18a9bf82ec8e9a5fd2c1e3ff92a39520cc4cf1cf28e295904ce59827"
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