class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "f4ecd6eb69032e4ce201c6064649fa00c747012a08448e328070461ab25271cd"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e7d941bef933aa754dc9252530b6ece74fdac8595ddfb30500d109763cf674f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f21f3a5fe8e4f85c6d21a28e87fa3868478d5d3b91bf79707846dd80f9036d42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fce44e069b0f3d349b138d1b4e87a575e54f10e3415641772ecefcfb4dacf585"
    sha256 cellar: :any,                 arm64_linux:       "283b2c88ce2c3e0bf2201f8f89b5e9894f3c53cc80d9f1fc9eedaeb5ab940075"
    sha256 cellar: :any,                 x86_64_linux:      "8c05aaed254040957b6f666c9c47481cc08f395a9c9c5ccb43f5968c60d34f77"
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