class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.37.2.tar.gz"
  sha256 "1bf934c6777e7285644dd79bb9f554f63c0d34d50506523a9b2d02af5cd7d79c"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1896b74923156cebef2c60490405ca4bde8869af0f20faffbb1b4da72a87b654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca4ddca58808917fd01cf98e45c40206c3910e99698d24cb7864b4dab34a7b9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a82642bef14c5a2bd7dac20af2aae87d362c30abf838e53b36458c6dbdf8c14"
    sha256 cellar: :any_skip_relocation, sonoma:        "16581c39eac0ad8bb32239ae4aea42520cce582a2d798532766fae5f8d11f78b"
    sha256 cellar: :any_skip_relocation, ventura:       "e794cfbe98f2861386991e7e945089c37fc622efb8359cb9453c7fbe2a117358"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39e18a04a3ebde1b4a184f7e4e19ba0489eb452f999cf3fd64e426e90a68e23e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2694cc9cab541db1611914a28b6bafbccced843dd83890795b84762707d710a4"
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