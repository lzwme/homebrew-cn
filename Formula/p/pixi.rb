class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.28.0.tar.gz"
  sha256 "ce55ee2596ed4fbfe4234c0410a4f3a66740d42f5864899428037945f096cea9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3320546e1cee95a6679213ee4f2a3d25a5c13d4c33f703010594f48fa53be103"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d710aa08535d58b205c447dc44db253cab502c7475854fe4f4f734e513048eff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0e228163e0f4970f2837ff43639ed4168aaf9f2be0864f5f2dc9c7784c47000"
    sha256 cellar: :any_skip_relocation, sonoma:         "35225295fb75bf98e75d67c263bfd4284a9b76cd6e04de8e6072c3532b0ae4e2"
    sha256 cellar: :any_skip_relocation, ventura:        "feb2417ad0cf6c77ba1aa477b08edf93f9493149b6c4135ccbffbb597bf18b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "fd65be19e705be924442155256301f20f237376455b9a5ae6aae435d62bafaf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4eb947b59c9f144da9a9b77eeb3680fb5f9c87bac279553a760e7e5b6917c8d"
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