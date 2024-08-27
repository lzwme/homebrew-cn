class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.28.1.tar.gz"
  sha256 "373aaa1130be73d3196e7de3fa1f99c438b3052a3990b83a87e4bfcfd9b8b45f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7065eeeae9e2b054abe23ac163accfb3ac570805a7ed716ed33d028db220336"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11ddd0191ef9c603626ee339c15d6c883cab1c12dadb2b7905471abfe754e376"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10c20463676ec6801f108e0a80d7e4918aae0adb790aff56b42166e61504d8ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "f38aff3f76b4303c046b06f719c2b89bacedcff62cfe29466a1ef7fdb6151af4"
    sha256 cellar: :any_skip_relocation, ventura:        "b1fb5c2835ba51b578e7c48c62929e8973fd638f19932499ed322f4c7d3c7a4f"
    sha256 cellar: :any_skip_relocation, monterey:       "6da2c7895d256e5d20787d7a3d999dd3442f8131bd58068bea78a5502c6947e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "953a017fcc3dbe3fc743ff670be8cd656aa0e4a4ef47280b36befeb5d0199df1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip

    system bin"pixi", "init"
    assert_path_exists testpath"pixi.toml"
  end
end