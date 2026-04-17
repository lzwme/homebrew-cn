class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "2445bdc80868607f0c31792f914d87d5ae869ad3a4ffc5d1936f6221f44fb00e"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf6768a49d17c2e9560394b3724b1abb8270994ccac17a4add66662a29f3dfae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81c73d44ae865017f246ef904d8b1caec10b8904e8c694b3e8c047a9c3598695"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b28abac13c4360ac2ad5876cbefeaead26bc969921c492a2ac1b71337a4355bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2e92994a50345b154650df754f3430ed516a5ec2fddc359bcd19f634dae120a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd0349914a917d4e3899f7990de7eb79896315488d1c1142a111252f993e39ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0824eb4f0d684b2f8908f144e232703ecb3a7f8db20eba93978840ca35c487e4"
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