class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "29e9b24198ddf8be72a851e7c52746db80a136708460b4f24f49b975185d397a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539a129ad349ebc0efebc70cca55c7dab159d9462e8d1f69aa4967c53af1e881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b1f5c7898ee1818072a15c75544f078e253680039c6ae05bca86ff88da3d749"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c1f53d457ddfa9977c899ed563fe9443c907f7baebd349b4387ee695148262b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b30a47ead35695c00ea56727d67afee12a8d1b15437199457049c652c50a4072"
    sha256 cellar: :any_skip_relocation, ventura:       "8a492247e39cb0f5a0c59b89673e2838b9be2618a9ef6654753b87de3c93f3d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb21415388e2dc8f101fff0ff17efa9ac1b757d13c04e4b912cc31af91f7e58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45926a898d4824fb76177f87a0b9f9fcac25bb7193b4fb1e301f90faa383f97b"
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

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    ENV["PIXI_HOME"] = testpath

    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end