class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.35.4.tar.gz"
  sha256 "de52e5a9cc0bb10bce7960b67cf6244f1aa2201464ecf896eb146a01c6dac031"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b04e055d07e66d357ef9a648885cf0d7403b42cfdab8fd6be17808ee3b9ce2c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f3ecd69ad99b29e564a6c7b53ae025c801d09cd2a54d91d1391421a132e06de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf0f0b11157f024fe4dbdf19fdd28dec7b2a2994de1e33ebd1b2fa1a43282a2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b50b92771c35560abcb29e0d61e7008e281b0ea3b469ee341ed41c853b608ca"
    sha256 cellar: :any_skip_relocation, ventura:       "5b1a46ed0e02fd51bb668ab388387dc6e7b248f2de87929b701aca83ff80e2b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f62ba1143a5bf538c53291265bd40cfc0640210edf653ca37987d80576c1005e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d45bd59896506417f4f545e4b05028100a42384c1f76f2a44ce56c274f7b2c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, MOON_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"moon", "init", "--minimal", "--yes"
    assert_path_exists testpath".moonworkspace.yml"
  end
end