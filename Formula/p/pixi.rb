class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.15.1.tar.gz"
  sha256 "2c73f9f4d597e1969f3fbeae83d08752d99bcbb0137e5e9179902b596e2b3839"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c34b3e7d851833cf1a3c02f4676e9f25a746252703bff6ebb2c74e1d0247208"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "778a415aaeb02da52864caa8b7c43833561fb9a7b70a8a95c067cee1b869c23f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f58094e5dcaf59c46a89e42e9bf7cc440cf49342119afa21e6f67a55e9210c7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5b7e2a4aa3419bee62165f79f2fcd876b6e4c6eadc822a7906c8f58fef3fd4c"
    sha256 cellar: :any_skip_relocation, ventura:        "f89a9210f6c9ac385823b46ea20ad39b2c2fef16f602a3e3618dbf9f16e2ce91"
    sha256 cellar: :any_skip_relocation, monterey:       "ecca340a0083a05e9fe7d12a3639633062cb29d45deb970d5e63d23ea2e15fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e2c35149cb2f7f639af5317434135aaacdd78a02764c203703b218852b0b2f4"
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