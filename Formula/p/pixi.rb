class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.40.0.tar.gz"
  sha256 "41ca34cc0112374c2268854fc66e0034804a1ff31e4b75a0238eeafac85191b2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c77e9d4b1acb94afede760494cf7b70ee83cdcb7e5ef55c2916ca04b5cbaa57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be53df0e6a0a93f87a4e6efdc7a13dad8428847f8258bc047333638827728976"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75a01b971055f9f65a0f83735ab74996faa1874e01a182e572866424b25ca0c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "eed004352bd8d5fdb8f6f54344f2843d27db121eb2276f9097809230605328e3"
    sha256 cellar: :any_skip_relocation, ventura:       "636ae774bf4c7cdd688ee60b7e5c374224eaf483bd90a08b154a25349493f456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc4b8a26e0f9920ccc1850696acbf16275aaa7640c9d08886f903bfd74535d76"
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