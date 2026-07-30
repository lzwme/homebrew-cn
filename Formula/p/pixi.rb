class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "cb261e285d57c26584a724fb8837d34f3343003006f16e73949113a27f632de1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40d64cea9220ce87b21f4a960ca01dce60b96435859b545722837b38daa61da4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b440a900fed0ffdb420789948f1aa31510e4675e64023273746dec2e7f958246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a74e90ed4207f20f489b7a43e303eca27884d43f591111224caa35c73fad78b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b8d973387ca05be9fd9bbdc31fbf48ecf03d0fade56c771b72d9d9e2b70af66"
    sha256 cellar: :any,                 arm64_linux:   "28567646b9276bcaaba8737184d8233ac2d0df9b373480fdc26ff185fe90307b"
    sha256 cellar: :any,                 x86_64_linux:  "fa906bf0950542aef4766613bdda0f2fa5ec5dd27ca7fe8049d8881250637efe"
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