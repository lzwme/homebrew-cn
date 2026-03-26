class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "f1d1f6cecf0cc99ccd9a15dd25c2412f3b6cc6a1d10bf50fb720ddfed6f507a1"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51a5e8d13b7a625a96c82c14eef04f07af3174852e41d182269dc971c53a76b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b66edb951b5dabf54e5d2274288bf94beb8d4fc28f4485bcffc2008e2d7de3e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "471899ebaee84f0c702e4f3851988b4b63ac3cae69f29979aeac89b9f28ce8f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "45b91e6599ce364c797367505966ccf6a1cad41b3d00f606da8b702f733f3ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab50671ee65768b536ef1be1f505b9cd5bc9cbb7c3b7b9d1dd7f4b7218ebe0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a32e48529f7416d409c7abee0ba820228e55fea498db25050b2b0eb2e382b1fb"
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
    assert_path_exists testpath/".moon/workspace.yml"
  end
end