class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.35.0.tar.gz"
  sha256 "22f5068ce1652949f843e8e3770a95e269f2b1dfe6447a4452e3b9fd12b6c667"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c87c439f36b53cababf38107cbc018983c895e7854f049cdfa5d9d35af2fe992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd19ccd7c43ee430f140bec26ee569276768e8f5a68494b247b16a817b93db88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a268b4bff2e9bdaa74bb1764d8cf32fb17fbeaf8b05a4153ee66b3029cbd90e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5864685523fcc64598ae24ad3d5af075045ee159cfc9b0def39ac7fc64665bac"
    sha256 cellar: :any_skip_relocation, ventura:       "dfc6cc72763be070c20dbaff8b16c95d8270551a282b6f2b146d2bbce06f5ef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a7a26c391ab7b555881d4fcbb89fe0d9db33e015b11112ef80ffdf7863394c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cde0c8072535de4f0dd949aa0140e8361be843bc5d02c0712eb3bd4ef5b28cf0"
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