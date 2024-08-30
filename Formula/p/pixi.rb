class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.28.2.tar.gz"
  sha256 "14e0912727b657186234555477c9009cb202d50a01c0e227cc96aa96999f0fc5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d15d661905f9673a97007834d3bcdddf07cf1744d53ddef6310db7bc4bf91b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c6251bd9ff3379cf75b3093313ab3f4e76267ac27569e58b2fc37b7b005cb51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e3d4351c29cd6e47972be4c012b10e162e96100cec8271510ba6a48d1629380"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a90500486afe461f49637dfae828ab3a07c4531639c5adbd2385f53c355ad5e"
    sha256 cellar: :any_skip_relocation, ventura:        "af9a0e54cf5fbda015ebc4e0a75749a2269013e781b1ecd9c2560ae1f4fc8940"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe19e06748a489a71220a1d9ae5276652b9e039cd462327fc68316c6ba6750d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4db49c8710d585142f05ce4e7a80b0877beee661f4c7af38f8a98438e0741d48"
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