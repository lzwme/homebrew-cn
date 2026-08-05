class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.76.1.tar.gz"
  sha256 "7b7458bcd6058122a0314e4a270e0ef7f877a9706c2bc00340a69cdfa4eb94d3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06ac9246023ff9dd44bcf5a2d3e4be7642b2b045957a093aa7ee597d8f16f062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca36a4d45a7047469c1604ecf5de3b507414aa19f643533a9eb42637af2e1dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0580adf107505a7f79f9470adf4014fbc15132f6616587e9377b58af4fdcd5ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f2e97b1e8b74dbdba8565779e7934629bb3f5678e6602358ac50ae17c86d4cf"
    sha256 cellar: :any,                 arm64_linux:   "d9851a232b14d73cfa3eaa0258444cc89f112303e1caa8e515a9c69dfda3b1de"
    sha256 cellar: :any,                 x86_64_linux:  "8faadf5671547deb34b4c7b907742b77d2f2d7e11165b79779a7e6812d353fc8"
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