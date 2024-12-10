class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.30.4.tar.gz"
  sha256 "f47592d94c041cc83cf665733945a3df3d10b63f45c5fe5368f2e2216c2fd972"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80ca6f034144dc15a15e5c4d92b6918f67bbeec793d54fb15b003728f7a06cc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23f227c667ec702a9aae908e61587e64569e398a1f15c569e6cf3d80c9b3d5b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1058e39caa1d86044cab1fc84862a4ccfd2e4c8ab0ea10d99b546807abe629c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d68e0d3d71b09d6b04b7bf74278885b1a0a3d3b28fdfb86121fa5b00ff216459"
    sha256 cellar: :any_skip_relocation, ventura:       "5be7a4f04acf6b9c47d51f8729d58643c69a0f94dc3f9e70b1c6cf5f297f9a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff913712b389711910d3db1a67c2b4a9892f999d8ff3dbe0d4e02d05629a1ffe"
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