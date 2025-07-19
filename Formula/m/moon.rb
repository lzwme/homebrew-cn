class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.38.6.tar.gz"
  sha256 "889d0d9a75d27b4655178473904538976dcfd3753f88a14a6f4a4e2c7ac4f73c"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abedbff473a6fe59b7bd18df712ae497bd6a6fe0a80130345d4c69658b9610cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21eda8023a0bb42a7dc838a9df06948812d01f714bea92e4a9299f87e04064cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12a6ae0dea397729a383247f5a276b6b43408284b66b5fbf203cd3f0fc24e0f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbeb3775605487683db1a80a86d87d670ae568a84cd2df277cca5f00b22bbdd1"
    sha256 cellar: :any_skip_relocation, ventura:       "d5067af83bc01abe194447b08df8125f4003b285372d210799c2bb1b558414e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eed257aa0f0672d18d672206cf13f5006fea663188880ff7dea3cc073de87d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642daf4acd8535c5044763fef9c3dfc51cc7360dcf360cdb6fec83ce92cea8a5"
  end

  depends_on "pkgconf" => :build
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
    system bin/"moon", "init", "--minimal", "--yes"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end