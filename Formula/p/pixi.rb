class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.27.0.tar.gz"
  sha256 "cbda3ffc597289f5f031a30c854e74da0c4d31993ef9398868c73078fca6c452"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e164dc3bb66885daddd7b2f979b14e5ab7cfb868e39ce798180bc7921795151"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fd710ec77abe27cce40d084804c40b4ed3bc018b11e1a335c2028ba324c7d10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7edd7582678d144e04dd59efa85b45443d86d6c3892ee03fe1154f01504cb9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc8d351badc116afa95ab4348d7deab5130ad4f29ffe4ede7761cf2b8b6deb09"
    sha256 cellar: :any_skip_relocation, ventura:        "58bdc83964be1bc81ed38bfa030e51cf8c279ff9d305c357517d123352a1de21"
    sha256 cellar: :any_skip_relocation, monterey:       "00a6c254e195cd48ff8e129cdfbda4b27c6a04884b546bea442e55eb4212f195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9d23b9d45e61d792194cd035d3a09d08cad5fc77d39dd1a7cf8a85e8dbbe48a"
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