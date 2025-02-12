class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.32.4.tar.gz"
  sha256 "2c57c5e3feabedcaf76a6f697db9c0e6a4f01bf42fc56aa4f2cc7fa65d7d4a98"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db1c4b0f4361d712b4c5561360c70f7e9b4af2d48e8b254fc69e3cd08a3178f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8cb4febdf591c97f4cda8478afc2b4f544c6bfa88a6767517a461b410b5a8c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0dd7dca19083b6ff38e3f041cc56cc2ffc2c7d6a9e935265f9116eeb47c796a"
    sha256 cellar: :any_skip_relocation, sonoma:        "978893a43b28b22af0071f7cacf42c3b306795a6ad4005c8df23a7d184ae97b5"
    sha256 cellar: :any_skip_relocation, ventura:       "b25a6a36e188f3cf3e17dc55fdba4e50825f2380ce5a52f7eff31003c6aa70e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff2b4ae770f5ca13e35248499538d5d70ff173db740e890333450f26e7b7a292"
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