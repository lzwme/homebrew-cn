class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "61b3ab95c759bf45b951c6639038d6eb5e52763d0e3d5dff65bac1f139aa2150"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a41abfcfb5d09a47e4db99aef7627a6e9f1a0e02c94f1cc02d218f7e66930a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1140fdf22ef728985e86415a516dc25a3f24c9ba3b0e25647cac7e282a57a035"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4053f112a441ca3adf1e12640a5fb963e8e2c4ba4a11190ba770d09aa99e5dd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d58a7c6ec30b2db4ba3bb6f4d5f6fd617d84d1c54a1d45581970af23b303070c"
    sha256 cellar: :any,                 arm64_linux:   "cbbb87366539b0ba230d1547232ba4be4ec3a93c63610e05e6869f314f3fc5c6"
    sha256 cellar: :any,                 x86_64_linux:  "2d234eb321de4ccb0998ecaf4816e8af09056ba19c759e01383ee0e9e2ee22af"
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