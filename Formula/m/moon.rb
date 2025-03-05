class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.32.8.tar.gz"
  sha256 "19bd86db3e326e0550dda0a45d3ba2cdfa9d44710fc1b4ed412ff72ce53fbf54"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be96a03f5729942065b16008044dd65a2ba6d6e2bf958c861bf14ef5b311f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5c63444387b0e63993cdd3aba606dcdf6f20ec7efb018a49fd4cfc1aef52ca0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7afc1b95986c27f4cca132f91bffa0b1bb068b134bb619fc6a78848c2324c9cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5a0ced97b0948226d033ec02859334944a63f12a471a2e61614983d4377e315"
    sha256 cellar: :any_skip_relocation, ventura:       "9130d023e578bc28fac9129cf8f2ca3ba8a71d73480be4259d241cfc226b6772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9c43f1506549da1be179a28709f0bde5af5d3f702e29993db49562d6424088"
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