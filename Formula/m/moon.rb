class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "7664538e0d2673420885527255ff26b305883af9fa93173eae249690a1c38150"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49e0e2545c4e935cc5563a1795ab8d646ee40712ab553654244197befa0b3b89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8212b313c80a41bf8c6745a5d1911b153e2a76b81d3b26108ede36f42315962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dc0e912c2c4dd14ee6e6915ecfbc1da20337acab9789f07a573b7320d9a7856"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b200ad587a46a58ecdc0d4d92b925f3f680e2e03787324f8849351e98791776"
    sha256 cellar: :any,                 arm64_linux:   "d31dccd037ab335a524b7787fe482296195387c701cd0948ec5186028f0c3eda"
    sha256 cellar: :any,                 x86_64_linux:  "8e874817a5a3ec60d701572ce8f46f9ce7aae0b86f8b748d7cebc0a0a14da8fa"
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