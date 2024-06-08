class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.25.3.tar.gz"
  sha256 "71d44f5659a738c43dcbd87d4b90e98251ac9bd68bb666ee6a721d29add01e43"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79c13652c0ce980e478ead98f488d29edb938aa096ed215148fd0169ceac54fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "091caa40895579e37748113f16a1077abf53cc1d7505ab48137d432ca49da8ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05c301ca9773638012e0ff1ded15f0d0b7b770ca41a8824fa82f97337570a873"
    sha256 cellar: :any_skip_relocation, sonoma:         "877f10097fc6b554a3c660cd539c757f3bbdd20e2b7022b7c89b0a302b26cf4b"
    sha256 cellar: :any_skip_relocation, ventura:        "80aa49c49ed236732ece0f9aaca390d64e0a92ae99e4490cb40d77e092c2aae9"
    sha256 cellar: :any_skip_relocation, monterey:       "c613a66f2b96ef3d82a04719f90d878a7230d409ea65f08ea393024afd079b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50470ac379ac77e1849d00389806d9eb309c735d72879cbb60ccfdb2e7301d3c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "legacycli")
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