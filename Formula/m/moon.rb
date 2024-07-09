class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.26.7.tar.gz"
  sha256 "bb78380c476fcb1af294b46f6376ef64e5c4490cf55f747fbe91008d0dc0383a"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f803301bcafbd3fcc9c2074f8d2b4c96bf86440f00d5023a863db6bc8b308f86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16fb930b7bfd334a1d93422241b6120a1fae0cb81f568251c32afad977caa122"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44b75592a3b77f2d2eb4cc579ae4c43bc60d7b366fc8118ce1c512953104a72c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ec3801939880737a8ad32da5404d7e49149ec86f4f7b06d437762b463d20618"
    sha256 cellar: :any_skip_relocation, ventura:        "bfc8cbf33cd62b1a676f3f9d91e575323958172ec872ef98ee82ae7ea52d9eea"
    sha256 cellar: :any_skip_relocation, monterey:       "f820935613eeadef64a329d2ab7d987005c745bb1f4cd8001ce0bebb91086ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bfd3992ee359d1f1aac2496a623650961a7466e38c657bea73b2cb7429a9b27"
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