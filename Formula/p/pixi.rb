class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.11.0.tar.gz"
  sha256 "6af563f1a699de7d2bf099f860ae0a3d4964c6901785c5e0c5c155bf65000b9e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "836c1cb6a240dfd08eacb8b5eba65f994530b48d3726fc5a2e052a5c46deff1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9fb9c430e011943a8b4f828faf5cd4f74bbbc72821396fe34bddb3e21c81246"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34d379087513bc23dc6592cf1a67984d80853407207b875938c967fdfb15800d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2037df2d1de71704b428f448557c092a84d6db3f906155e0c79377d922d33203"
    sha256 cellar: :any_skip_relocation, ventura:        "0212523cf1382455ae9586bb20cbeb5b108f7dc760703b6f8c3dc0a417cfaede"
    sha256 cellar: :any_skip_relocation, monterey:       "71c2f6413497639e9fb03d4a184a8dbe5e9bbac5f98942ed8d374b4aeb0ed674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c22d3ef78dbefbb937bfac406defacf6e2a47128b8e77ea026aeb058558d54"
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