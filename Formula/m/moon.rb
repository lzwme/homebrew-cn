class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.26.6.tar.gz"
  sha256 "aa27c71d3478e55ed75ad0ec5f8a2f81ecb855b4b67e9addd4601292ece9b2a9"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f70a244dabecac887a0067974dbdfa356cdadaa03030c1f824e29580eb14c01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c81861b9f5f6e8873b4f152d1bc3bc254a357abfd0b4fe8728c9109db406dcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10d5d5047b1e1dff2249a60929daa73adf562667e15ba5cf52f0b6569a7f283e"
    sha256 cellar: :any_skip_relocation, sonoma:         "aee7e95e115855b1526b9a1dde1279467398f059006e7be5aee43de665df5745"
    sha256 cellar: :any_skip_relocation, ventura:        "ca34495878246eb495c7fbde688f26e1ac833276a3f168ec1045ecc4f3465c65"
    sha256 cellar: :any_skip_relocation, monterey:       "efc1c1654d2221a7a1a369e784170804f10d3e42c332e73d32928cc57abbca67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be3a3ce6e88f7e44ea0809a49f1a3bc12e103764a672644b014ace5e996ebb9c"
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