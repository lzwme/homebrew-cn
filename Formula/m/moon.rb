class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.27.1.tar.gz"
  sha256 "f4a7ca636602753471b68fd4523c89ee3fb54ac82897ee4db0bc86af386e4ea4"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "081440f10d35addacaec6e0f08d29fa54c1a458b68e399f607602d6b2e5e5419"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42859ed70c05dee66c6c24e50be39eab70d4ba9700bacfebd734e1a747236958"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bf60a6a4b7cfb90901a65a103069c9dff7a5048007653a9b30615588c07bdd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "98eed332e3102fb628bd8f61502b32e2e51879d18c085a22170d2f525725355b"
    sha256 cellar: :any_skip_relocation, ventura:        "59e4a84ae076d3b04c87d5c2e6c49b91e0ad80d3104c2b8ec624bcf164af7a45"
    sha256 cellar: :any_skip_relocation, monterey:       "6fd8e66f62f02d7cd4c037b84a132fa74b43d35f72275e0772e1416a76ff2b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c49742c44c644e7fa201aba102ea29e5510a40a10d1a1bcf9a651fa05080983"
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