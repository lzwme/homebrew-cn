class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.26.1.tar.gz"
  sha256 "f432eed9e0206d87ea548ad313b274874f4a0e8f499478597a197e0c84372b1d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8d38b1aa0251db764a7f25b4242062cb8aab15c409fc4dd646ea1620e0f4e6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4593d101b84c25ced36a7c9eda0f07b47b075bcd8a836366b5174a769e5bb435"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c68bb594daba375365092a9c0750fbc3c3f0b2be0cd53a44739f0b00fdbce88"
    sha256 cellar: :any_skip_relocation, sonoma:         "38e49d4fc6df6175765db907df6b7638876b056bf81732defb3114fdd49327f0"
    sha256 cellar: :any_skip_relocation, ventura:        "fd5c392bb60de995cbb4b71a4226e94b128878e226a2d33e0793c559006a6b23"
    sha256 cellar: :any_skip_relocation, monterey:       "4c09ba9c2393529c0d8c0c6c413b59ad563e1c19d32d516f093b85c2b9e8caa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee42f0c28b7306a966ec219e6d06f2ae50dbd784dcfa6e135c891103bbef9ee"
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