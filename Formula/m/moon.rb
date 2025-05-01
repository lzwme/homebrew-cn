class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.35.3.tar.gz"
  sha256 "7fe63f9e7c84021264a137f2c453eaab1e807590eb8b3e9516797cf8a827aa50"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91041e6bbaa18fa9d8f2f51ee60893f2f0c7f9b674e5ded6bf83479950957f83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ee2b54e687bbf25558cbd5a303176713b1d7e2993446919f30bb59aaefa90de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d829f8735ae0729f0607b3c7e93a9b1b0c26ee11877f88573341d91a0ad254cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe6cd1703de34d07bb232844eb1e05f61e13c5cd070c23c8442f5d8535ba40a3"
    sha256 cellar: :any_skip_relocation, ventura:       "e5d7175b284b6e363560918331240c7e8127bdb8f0612d969e80fb9389fa20ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa063a57f1380c1a9c51767a8ca01f91c2f930df3c708e555055c48c328b90d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a416f7f26e0738d40f02f618c839f552edc8959ff75649f57f311d2d5aa078fb"
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