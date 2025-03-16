class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.33.1.tar.gz"
  sha256 "074b959b4fab0cc819e3a595260707d314a052f916bb23f825f3d2b28d5a374c"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2aad87022db7eab81e7180e0dfd0272808ffdd35c0677085842a2ed8f4268ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9846defe9916f52d9257cf59e07bdd0d9344bb2ef9458b8bde8d1c814ce76734"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99e9681a5443a398c8031dd0f3e27d2a1ace67db3284eb0f1d0c9f811dc07998"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2c941a3d0239860bdaf449d47445e5247ed4856e7ac517ca8848e9bab86d340"
    sha256 cellar: :any_skip_relocation, ventura:       "1cd30b372a5eb2483e9f3f50d606cc608f0f35576fb58f96075f74134d2deb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "015b7ed98895dc218112511aa266d7bbf332d5582f46db1108cb82ebd064be13"
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