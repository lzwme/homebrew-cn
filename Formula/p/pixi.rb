class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.29.0.tar.gz"
  sha256 "f478b78b26708748455a843623fe5bd134508395dfa3d540de83fd8c05d43dc6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8c55b200937087278ef3417a9453395441d43e90f08800d9454b106c7d5fcb57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "159b7fdb5a0dbd38208b188d90deeff9ff5b435363f5af8a534bc6e76c9f5408"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbc9dc9c8abe2605a6e938b7f988892f04aadaa0901f04317e067037844c1a27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71f3f3b64c9d0c76e9750ecd13129a6ddb311ec9177b66505bbffa28ad186932"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2a0e3f46130db4fa4523cb400ed990b31cdc6e4b1201910e23569cefd1db0e5"
    sha256 cellar: :any_skip_relocation, ventura:        "91354a25203f68c0c1d435966112b3dc8da5d6537508132c8cc72f890d6469c9"
    sha256 cellar: :any_skip_relocation, monterey:       "e6fdf187f67f2d6c81f5529086429c9f9059a8798ec322d675c22d94817529b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099cf7235367897db8b89b097108d91bee9444effb6bc014369868841408181b"
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