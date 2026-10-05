class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "89bd2d1edf7552f7ab1b1d4c817b69a7f0d778dfe2a220799a6e96a4f4b03e76"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40b64bb9a14399a212c89b1bbbbc93136a3bc4edfaa77afac8d369bb662bbb6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27b2686feb2c3111ce2f94d0803092f991c5de0241810c2f8df8aa9eaf66d656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a269927d0564af2f6cb77fe6a9cec1c5bc60f265a1a108de008439214b736bfa"
    sha256 cellar: :any,                 arm64_linux:       "fcfaa29fb73aafacec4fe71affb1542382164dd0bd75a170e7c68298a5f2f9ca"
    sha256 cellar: :any,                 x86_64_linux:      "ae9378140075ad4f8570b8f2036c06148682ece97f5e29bdd45fc4ce2841b33e"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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