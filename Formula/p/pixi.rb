class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.48.1.tar.gz"
  sha256 "02114cfb34d8527527e8368a5a83bb06aa07ae99724e88e8139052be58dc809b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b4a7dbf3e0d78027e04fb5f069311ffa9ac24200133f31cf431de389dd12e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71f4eac89039a14cffa7ac560d03e2280dbd6ac6d42db7f52f9411a3e7781367"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebb573c26fec48be622f1c8fb24d8347447c0f75529dd88fff5b842a8a59af38"
    sha256 cellar: :any_skip_relocation, sonoma:        "9991c6b3f78ab20abe5e8816aa27248fa29fcaf36e6687d92dbab155e636c8a4"
    sha256 cellar: :any_skip_relocation, ventura:       "8f8a0b3afe66ddcdfba1c011019601168adf85e5c27080444210aa56dee0d33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a20e7a8ae69d2c37d59ed0c0f96ef9f8288f7226d2f9911048f193738d190d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f78138907bf8a82ad4d87016d682bc464bca594dc07d4dbab464364002e3194"
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