class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "87a53c3b38bca6211b311edd987a706e7caffe017cc5e2ba1504386e0868b103"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac00d8ae27e9415bb40542830019235fd22fdeb0f6c95a79ce963e8f68e91632"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a4565eb455aaa57931031e97b4f544d5049a82bc44abf4f8fabdbb8f344b872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6790df48ab36acc756a67a95a9c941fee5261cf03a0a0877762b74fa6fc50eb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "872499f0cb4981fe019b26da1c1a04ba465034e33176bf3e8f229ce2bc07de9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48251b71d5a57ccd7fa18f9b5777da6143ce3e878d4ae38cdb05cf9273ea6a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74218b18992375c26431481a7e687abe92beff40ebad6dab7b18c36f0e96777a"
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