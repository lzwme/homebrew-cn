class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.28.2.tar.gz"
  sha256 "07492f41a4a25c9ddcfaea533f77b500409c2a77e183179a1a093b85786c1153"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0199758d1d5ddc9d2197dce046d3b7e9ba2a890bca8d548e451d53d249285f23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90877a8bbfa1b549ace17fdf278a80adaa4025fc7cb36aeec630206abf01193b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cad3cd3890d6e19b666b25772931972db146baf8727f1e38c8e147b78147b582"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a97b2e566f062f92f989604d986b0382c7a20f18012f7e3265932aa6c79233c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc68a94876a41daf9dc7db59f662e041192e4b501791dbecc8c8efc377c7e0f1"
    sha256 cellar: :any_skip_relocation, ventura:        "1fbcbc7e09b26c26a56cd3d5a31eef65dbdd63eba96d6706e70754685900a482"
    sha256 cellar: :any_skip_relocation, monterey:       "e86f261f597bebbd6190749c41a8c4757e0536f6333e5a93d36eb839d29a62b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce7bcd0c9b698eb433f2e6ab052eb074de1bdab94d60698a55ba91b5be9762ed"
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