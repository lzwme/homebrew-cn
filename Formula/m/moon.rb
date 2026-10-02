class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "40468c58e99071ddeb3a1c059dc5640d7afc911e55d1eca89f7846e2315cf33f"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92956b643e0f83126b34c090c41ff1805283995a456b2fce8a2addfb8ba75314"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35a9691482ddf831b12091ae0089de94edf100dfba5fcaa6fae46e54cc97d09d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6c5aae39f02d3cc69fb40fd0ce814941e7f3859ee165640125e1440b0e69ae1"
    sha256 cellar: :any,                 arm64_linux:       "f3e6f9d081bf34301ba01fd4b92b4464dc213f21f6bc16ae1c699d98b6411a83"
    sha256 cellar: :any,                 x86_64_linux:      "25e015d865d22de73b39ad710fc482d11178142ca9b35ca387383bc8d28a8b19"
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