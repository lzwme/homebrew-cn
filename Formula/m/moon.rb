class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.22.1.tar.gz"
  sha256 "15a436b94741e12b2d7a524139018faacb50c76716c8aa869412fd51f82dc9ce"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f50ee5c124bc462f096f37e88933f59911572e948d537246cd1228b5140825b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cd4e6e09ed5d759dc976863cf2463f2309f59315280648803ee3c2dfda62123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee0c85fbabe0bce9585dad32cc2142ee78f98eb542835c0160bd71d870af1e38"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d61ba75a32377b4be865fccdec0140bd885aaddf5b1cb26cbb51bbb8af0c445"
    sha256 cellar: :any_skip_relocation, ventura:        "738313835491217ffdeaed49c640da16df3c63a054677d8c2dc6e3dcf74ee9b3"
    sha256 cellar: :any_skip_relocation, monterey:       "ea5b4bcb7b4535e9c827ab9f058bbcf4b45edfa5cb9b81d8fb4493782acac2fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "734624338a71bd01e79b3dacb15c942ed7406d5d3b45202a7dec32c0d290df6d"
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