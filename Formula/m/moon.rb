class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.38.3.tar.gz"
  sha256 "e457b1741c5c075aef84f0b357ad0828f6bdfbbdf586174d1889f366a44b74ca"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe4f033a6cb4526e01899e56d822a06d11d8999674c4ba480faa87fc9d5bc9b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2adb2fe31e65e67a6993d1bc4f447090557fd483cce3fdf9eb1a57440e12bac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e8f0f011b7964cfa8ea548a53bc2687f6820cea38198a61b1c6b6ff3f023ac7"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfaa715227ae10c2847d97f201060b244b446e56c6670fd66b88a0dde255707f"
    sha256 cellar: :any_skip_relocation, ventura:       "1e420781f7f0891019cf73839f55ef429bf10be32ce5d034c2b837822fc39b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "667a3a3987500fc6347a5b65a91998002ba8e60c5d88e81c41e0692aaa062c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a73ad844605437195afc98fab1c3fd7f9900463cb3deac86f2e67a005af8986"
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
    system bin/"moon", "init", "--minimal", "--yes"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end