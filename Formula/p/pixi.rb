class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.30.0.tar.gz"
  sha256 "adfc9ea6fce36b9381556a4f793927ac0ba7c505a75ee2106295d62904aa93ad"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ab38a424cf1af34e6d7a8383980524e7d0328ca4345b1144baac3df8f8e870c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b6837b1ae24134732e29e03036dfe47e26c5bb29368b2d4993e81be0e481bb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fbc947836393d3033abc8d1250f164d5e5e5b8e7fd2cc2898b3ede513c6532c"
    sha256 cellar: :any_skip_relocation, sonoma:        "eec4903c7d7b32220fb6cec91a49266750d9f0bba8629cc23b57544b8cfe252e"
    sha256 cellar: :any_skip_relocation, ventura:       "509be0c618f1182feb0475ad353c12f88445c777af7c02af921b8768ca12235a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73af11a0e5fb2cd6559e15cd18ec30d5f71671982cf63841c2dcbd9c50ccbd7f"
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