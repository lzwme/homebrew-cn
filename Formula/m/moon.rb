class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.32.2.tar.gz"
  sha256 "7efa00c757653e4d6c1d105ccc28cb1875eafc63cba01d001d43d4324baa1302"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d94a5645da580b028ab6ae2cef64f5e7c3c06512b96116a13aae472437a25d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e8ccf7c8b49206b0d0d8009d0014878789637b9347aa1dece09e4168f0602f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bae08983d61075cb4dfc15f2d0bb1a98e56bcec9e86c895bbc75314355215cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0deb64e743f776068d415c2a9744335ed099e2be929b1a0566dee098f3b6e76a"
    sha256 cellar: :any_skip_relocation, ventura:       "f4a0a18d1e9971147b78a59dade36586e7b331fdd0f9a2e1eae448c6cfef9c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4663c0d5b3d3a9eb5e3b29167e30002969e0861c49bfd0638a2438b479b2d2a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, MOON_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"moon", "init", "--minimal", "--yes"
    assert_path_exists testpath".moonworkspace.yml"
  end
end