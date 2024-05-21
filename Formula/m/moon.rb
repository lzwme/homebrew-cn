class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.24.6.tar.gz"
  sha256 "05a592d1cb2c4f9f0b81c7307169644a26d7342aad145533209f4b3449734c15"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4dfaeac9349859a6043975018d798ca2bd1f9df770b8861944103e3cb31f2fb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63135222ba304fd71bc78f1c171c834f9f89ff2da1f22b400bc89f4bc4545a69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cb37928d696ab8df694a91b25547a0479b98c77b63541aac4fff078047d38aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3dda10d073cd4b5c029ac8f463c93018678027967a2b20e7aab5b2eed6d97d1"
    sha256 cellar: :any_skip_relocation, ventura:        "d829820a217ee4b6af183812ba28fbffbe2841bc31e1a8d6928cb22e267773e5"
    sha256 cellar: :any_skip_relocation, monterey:       "073cdd4c173f1a1a7ecf86d38d547008e20d503645b7fa44d8cd8b2ce3014517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d95e28729e1eff79075bef244aade50b9f5a7ef648c12925c02408e5282ac3c"
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