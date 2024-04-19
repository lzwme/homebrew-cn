class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.24.1.tar.gz"
  sha256 "4ca0c4d110bb889fa8d5eaa48f2780b4a6615d1bad4a07912cb13d83d1d50c0e"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddaa6a76b62a3e6b04b17e042f22ac79f79baff8cb3c62a085fc97a0d0ec02b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75dc3a2e752e25add3812ad78d5f24e636bf03a2fb76d8d4da31874f85b7c18e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6abe1bbd2a84f4157063de60852c3c0167f669e405d2ab1e5320aa43b58a89f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e578bad84c493c68d459e9a1cba64e7136d144f5137a73a76afeb25b38c4d539"
    sha256 cellar: :any_skip_relocation, ventura:        "304e0d7367e8a555b8e0df68db4311ad19ab53eb3a588d0186b9de8bbf048cad"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf59549ba2bca94d953cdd0a9b3d12a00e7678167554a98fa926b40f08d7d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d7135ca08e1bd8ec0b2c6d6d023510ef1f7086df81cae64779b2c4e15d7b4ec"
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