class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.27.3.tar.gz"
  sha256 "74180f3c74965d9d0437abd92f20c38443ce76f16e57a5e5a1a32b43a21855b1"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbeb3284e360e36f9b1ebb4f56fd5c1345f51159ed37fa6a67feadbd626df770"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64e28ebe9036ef55be16b290588d70252b6acf0ea5665037dc9b7cf4dde48f87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18e72bf61a6a3dfcf23376fd592ec5f755225c2f1a12eeaa2dc3dd160aeae6c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "be3593437b8d088629a55b16dd1a1978a11981fad2e1a6f7f0c9c3698e15fcc4"
    sha256 cellar: :any_skip_relocation, ventura:        "8a39dfc305e88432d8cf1a41152c79ee07cd7ae7a79b0738e2bdbfa3efb89c44"
    sha256 cellar: :any_skip_relocation, monterey:       "f674806db152eba3e4393a7f152653d35b55ed5f0738cccf7f4e81488ea6b098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ffe5123b0bfad63dffa9b6ca15a513fb2ca8e93c7d027cfe626fb241a5042f"
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