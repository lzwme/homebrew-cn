class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "1404626d53bd1c52df292322a6211287c4ebec92fbb17eabba7a37a0c3b2cd45"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16dbde176adc69f087c338282c4360f1227743627a076e6c8eb739f79a875b8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ace929207161a80135204f7b19407dfe17ee82fcfd9d1b93e1174f62ec245bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47d9de57d685414f0926f088ef2c063b805f450ce41840bb7c4f7100ef331400"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc6db8586fa71ccca3e45e921babf31fb9b3731e48681ba6b147d32221fbd03d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd6520d9dc33a1cb18bcbd96286e146be6031a70f2c1ac84ce3ca44ecfd4e7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8209aad9115ac91aadaa38e55ea6b123790ece5bdf45cd1ddfd447071d30b8b"
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