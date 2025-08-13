class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://ghfast.top/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "42346913e069751f22d4187953ba2fce8894c61b2da4b1f5798453d9c94ff5e8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "552ffba4f6b3cd9a7967b80387b42a553a3b0f2196b0e0d7debafc3a0a7cd33b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba5fc8e56d07a09a7dc88f18747a9b896041c2902eecff31182ad0bd4df867b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0ae8ecd33df4b4b5ce5dc874152482b1e4ed8f9854353a0ffd13b542e2872ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "d33cfabc4f2cd7618e7df9302545898e4349cf8bc05add2994d5062c7b1f20c3"
    sha256 cellar: :any_skip_relocation, ventura:       "b0be5d5d67c36ffac2d261039dd749991c0523c5e505bdbb7eb8abb29b8caed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85849a023eb7a3d45009f87cedeffad5f65fe16a1e940769e9bf2e164ee76b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0cff7666015a1a16290871e3144fe129135bc27f9e9a4b0e2d5038ebfbac56"
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