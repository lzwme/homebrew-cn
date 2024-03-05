class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.22.3.tar.gz"
  sha256 "f21b8020ecc1c1aa137a58f464cd65ea6dcf5a007836f6388a3a34315733fd67"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9615fcf0fd174f7cf820507c5cf6f598e57d80684e5bd7cbc55657c128ed534c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "427ba2e7e821d0b6399e3a1b8ce80c8451dcd6726206cb141b6bdc2578cf4aa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0603e7695db3186d9019d2dc5755a410866e548a9fab3a309c61c28f1a96ebdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7ab8092cc755668341f0ce7106ad09c7055ad6692914cc6105f9bdcbe9b51c0"
    sha256 cellar: :any_skip_relocation, ventura:        "0d17b703e5860a44032ceb6e9faf90461797630eb048b107f0bdd8d346a6b4ce"
    sha256 cellar: :any_skip_relocation, monterey:       "cf8eb43561f3cddeb61f7773b9ddd85494b90b80b84c33c5c5ab3a2a2d672759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9f4ae93c92d1897005f7d4b88ae56ca0ef74b48a51e24104c4006c870cf02cc"
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