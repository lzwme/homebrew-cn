class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.41.1.tar.gz"
  sha256 "a5fe99433eb7ff30a3d35eabe66aeee01666bf7313e4933cce5ab55ee0e5e264"
  license "BSD-3-Clause"
  head "https:github.comprefix-devpixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e797f77cc5856e1375c9264a2e0dc5304693b6ffcfd5c70ec7fe8720607d66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa1a42b30aaf3baaed338f0ac77cb3d2c6ea569e0fda0514725006ecd3875dde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81759ca82e778c274ab5621e5b2590b1e26aae748443cb25629ef1343e790545"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dee92f8a3e83a8ea14a1c74ba9ebe9c13c904a43d22452e03c02dfb97df924a"
    sha256 cellar: :any_skip_relocation, ventura:       "5b77091cc3860a6bcef4da65914e94fab163de62b339c167f6b6b7fb4ac45b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e28a4cc3f0852003c4c1f61e3bbc90e6f4b5e4a6603f9d0925e1be2cf04c9af"
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
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip

    system bin"pixi", "init"
    assert_path_exists testpath"pixi.toml"
  end
end