class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.24.5.tar.gz"
  sha256 "ec3819da70839ff9ac12a25dbacf878c1cf68404af4d45659b18e082fcd5dd85"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0bc0ff9aef9e7e54c7fb48446abd086e48a6df47b8c32c24c78227b86af805d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d34218e1d8ce04e6173463a0c174bfef97f0c5bf3022abc822e6f5103762e926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "005171e82f60a4e1dde113d26914542fae57f2995fa5cf1124b8d1ad40b1f8aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cec8336085ca179b6f15a882cb5048b779cb528885738c83bcc0def073c087e"
    sha256 cellar: :any_skip_relocation, ventura:        "2962b1a86050c55ee940adb8f37b76e020d5008f791b4d926f22c6919fefa83e"
    sha256 cellar: :any_skip_relocation, monterey:       "e11d4e3f1b3f67faf5bd60d3f9f869ade752e64dda77eb3dc04cc8020f5eb658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e2bf7fe6e0d10b294256fafbbd656c641099eb7a0217acb0c4de3ae8f4e13d2"
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