class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.27.7.tar.gz"
  sha256 "6523c40c48daa6eba267be22039d26a8412960595478562b79646f33ba9b55fb"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0782938de5f15a2d23af0f6cf5a73c887c55be41668469030f2ec21822480e90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caa4ff136db0d44bc0a55230c03b8db18ffb4c051e7534ed9537d97fde383033"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f1e124c93533c5af83ae294661ed23d831975b85d3996c3320948cf8133863d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a017a560db9ba077136a13b8ccbe609e82135ca49ea2f4e7628f109f8b4704de"
    sha256 cellar: :any_skip_relocation, ventura:        "52eb9772889cffd1c73824e0e729be8cb8f3af806da22e69670678b2dc033505"
    sha256 cellar: :any_skip_relocation, monterey:       "c7c673c929607c19277d358066b2cf2ce972f73d8b24ba73a5c3bef3758b6fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d46cbcb19c1790d0a785323473c9dcdc04d51d5c24ac0d91891d9e01a9d9cf0e"
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