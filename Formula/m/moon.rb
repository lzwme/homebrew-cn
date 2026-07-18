class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "81706b65334b1fd7f67c775535c5246d7aa0abf160e7246f03ac258c1a536f65"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf1bd230cbc6db73cb284f13568f7086bc3fd8a25c24f54077e5dbfcd101d29c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d83f9239922379814b239493450f60c446ed825ca6cae6d5fcbba2c3130868a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c7fa522e4229b7f92ba3b46c864b32b7df4a63b2b9bd7c3c36ee4c1185e42a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad0ac529e14e8336f2bf930b8837c52508a15a4b9d4badda9a8f0e713852f04"
    sha256 cellar: :any,                 arm64_linux:   "572261324ec5bb9aaa89763518c6dc4fc198c4c6227be6309d92263c8ef3f755"
    sha256 cellar: :any,                 x86_64_linux:  "072d855e971c9977e5aa51f39fbb4c90b3b17150507bc99cc70db01bb2bb8a23"
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