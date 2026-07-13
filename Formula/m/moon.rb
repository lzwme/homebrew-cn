class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "406be487ee17a371e014ee220f507eca8aae913878bb9ab4160d2815c5f3605d"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83db9b43bbb8daa95abad264eabfd01b866a890b89fc2be3625ca4689d585bc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "783cb2903a284df2e9bec748efd77f16be449f6bdcdd84b4b54a2f1f53b87936"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dc03de3686b6a4551f408f7df85a0ceeb7bdd0f41fc584c5465c7b96a00f338"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cd491885d54044f65a28fe26de38426c6fe71e86d0fed54ee924a6425fdb599"
    sha256 cellar: :any,                 arm64_linux:   "401a2c1d0352ba32adc37a6df744e54ef2ff6b9bcfd2f3810412a9a6aac4975c"
    sha256 cellar: :any,                 x86_64_linux:  "f114e99c46349442fb3ab8ce9a0a50bbb5b78dd1aa2a82c5a802d5557fa102f3"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moon --version")

    system bin/"moon", "init", "--minimal", "--yes", "--force"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end