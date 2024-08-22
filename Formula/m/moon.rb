class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.27.9.tar.gz"
  sha256 "1e6aa81a5fc9c7aac59ac5b1ab5a1a66dad9320b6e19dec4d7299cbb5223e59e"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dad0c070d3a6f188618db5dcfcebbe1ca5c0a366ae24efc83327f66e4bbdc01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0afc93c0740d5cdbdbad329e3f03c1630f4d6e004634f9ea9e4a7005e10f5a68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cdf8c266b9c2099123bae516101af6e328079b434ca5768bd79431ac98e883c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b640b9166e2bce9e3baca55aacfe422c7e5c9d52a047b079d9174557c7faa7e9"
    sha256 cellar: :any_skip_relocation, ventura:        "7dfc878aab12bc97cc75971e94643406ed9f555e94c2aa2afcf30c00bd86ebca"
    sha256 cellar: :any_skip_relocation, monterey:       "89992a265768e1fc9ce032823bfe046017c74356cd6dc5298c507794bd0ebb27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71acc2171499ef786d2da18687ffbd8fa327c7bb5d8381dfd4a358b1998df916"
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