class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "4af6a7469dc2593dc50a97598a075c426147a4287bea71d2ed108ec771aa996f"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecf4a927ed4d55f30acf4e8df91bdd382da950b4092d280ecebb3cc9eb5202e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecacf75202e2a801c42af5ca31d29d4ece87081fa4e5d4d3c38659147865b09e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7ae57efff8ae1e5e41000555af968fdf5be8ca4274dc2c435065d4e783a9bd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a349660b3978eb67dd5a38f3911aab0922db621fb46ab4375e946f468a211721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bac919255d366021bf5056cfe0cd890d4d65f84bc2f9b22016fc0a7a46007846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba308a46554d61344a39f432fd0f29be3b95e98587678d9ae74534cb0413f5da"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moon --version")

    system bin/"moon", "init", "--minimal", "--yes", "--force"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end