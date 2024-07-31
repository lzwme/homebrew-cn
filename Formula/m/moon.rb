class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.27.5.tar.gz"
  sha256 "88461c6958c205e83e69ee934d785fee374dc2769079e188cea225deef1e59a9"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ee867be0f3dbdacbb762ff8e5cdf01258c8b5e9b49e7590d0f8346e74a35025"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7e6d3e880156a1ffb1659acce8df3c19d80fc812a9c1f75f943c1b2e4eb3311"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "768273baced4a13cbf3b9d8b9e6ae43c1a70c0779e7fd7a7fc6be7e79be40228"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ed44f798e4f6f95840ce5a487b325efc073507e8b85da76f3e65c3f49dac3f3"
    sha256 cellar: :any_skip_relocation, ventura:        "1c7a23b3f804f0f84c628725f46b4c420e9ca7746e8be78f3355f51972eeb0b5"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b4f0d1ee7fc4d98f3edd8ff966fc545dfd516b7f85b6189688b09adccdf801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e6babc46e09909bdd8f445e2cf1c7e78c8d136fc8c97a407ba2f15afe033e41"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

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
    assert_predicate testpath".moon""workspace.yml", :exist?
  end
end