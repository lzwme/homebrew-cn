class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.38.0.tar.gz"
  sha256 "3de2246884c17ae097c8224cb0cf6ef0a2c10e766d1929e5e56934f8c5381d6a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e939aa203d728db04c07f046d2a1974362fe0c0b61a15f1c7428e8d8f79229d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0095a36c86a5368ec8a3631eb68e22c8f690f7e4610933c9b8653906f3fd4158"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3420973376fdce520d0912cb84f879c7bdaad95934f28a1d35d0f864324f9757"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddc6a21ec38a84c2f6a69eb1a18f8021d9555e91f6eb72462ab0f00aeeb33459"
    sha256 cellar: :any_skip_relocation, ventura:       "a069352e20b4e9894d7acd4523bf781c662e3cc534500dbe496968cab6a6f8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8143aa65532a7e62fdbb3a6d4e7d57a067503a6753fe64cd83903237acc1efe5"
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