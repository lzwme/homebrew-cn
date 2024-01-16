class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.12.0.tar.gz"
  sha256 "99919d95508d3d561910d6f4724336128c56a7ac10b35f2c7f7c256bbac64490"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24c2c903e37a6e1911237ecce905ce9ef95d5c6fed3330432e278d29ccafab3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5007e1e38f3e2db18bd406fa4a99ba541f0d1736f973bd9e5303c2a7f49e2a62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c0f62e4cac38c0087b7e5a1623330841ccef569418462195aa585b459eb356"
    sha256 cellar: :any_skip_relocation, sonoma:         "0af3170b8f719d25859a87cbadbcbcf655427f9e91f29c46d96280d0176982de"
    sha256 cellar: :any_skip_relocation, ventura:        "ae75dce4852b3be6867ba556584f76fabe915926352a0037ffe9ef4bcfcc5b30"
    sha256 cellar: :any_skip_relocation, monterey:       "8cd455ad8be265351cf9e15631793fea3d40d8b39807e12cbc6b73f4f93ba5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fab98e226b89a655511c1d31c7ee60e1ff69d3b9db8482d40b02611773c63e0"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip
    system "#{bin}pixi", "init"
    assert_path_exists testpath"pixi.toml"
  end
end