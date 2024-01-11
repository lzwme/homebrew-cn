class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.11.1.tar.gz"
  sha256 "7dbb2382f4b0e4a61a08334855fbf5f41567c732978e27fc1e23a47e4205506b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be80a545e5ca6bad78950ab1d337fa13b43107f16c79d2b56a0c1d07ed43f58b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a31b2a856f746a5268de3b69ca02aa5ec6c8483f1b6199f0c3985cb95e6681f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ab54ad6370c80c737b3c9237c2a2234fdebd15d0ced9200a7994b759d5cf6e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce6ca7d97a5d0adca2e7a89a75b854e4701fc3765155b8ab5cbf8982200a32e6"
    sha256 cellar: :any_skip_relocation, ventura:        "a5f94ec60eb44ec4d39cf6d51fe8c6511dae7e80a45a43c2ecab415fd6f590e7"
    sha256 cellar: :any_skip_relocation, monterey:       "149404680f14bd250353cc99baa5a3f1c1707000c61a81e6b15758888919387d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d15dcb33f84db11d376decf4c9aae60c6d1c237aaf20ea98751f0c76c2dd92e"
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