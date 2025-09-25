class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.40.5.tar.gz"
  sha256 "446e538fd0b03bfde4fab1c4b6a87e5d2768628cb2d2e70c38b3136a3a6717ac"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70af7f69a078526fd28f7ae929ef4e6793eaa9ea4ccdee62857b9726c146aada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bb777e1f2dbd36f7debca56ba9a2e05e0cecf503e29c14f6874b1783a60c15d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b65b9103d57de85f4bf17b294f156459888b7a003bd0d41ed1507d694f09a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab9dd0d8f81bf69e7011541b4e7255d30dd628a0537e808c7f0c28b4c196784d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a9be259ffb706ca5df718ff1ce527cdcb8540fdf1aa9d224b1df31eb32fd27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8013901da3ad22da600fdbd8fd00444a0de772dfc4f197d6f01e876b93434de"
  end

  depends_on "pkgconf" => :build
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
    assert_path_exists testpath/".moon/id"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end