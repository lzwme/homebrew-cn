class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.38.1.tar.gz"
  sha256 "8cd7166eca91bb8ddd2ddc36eed7fe9dda30c8faea60cefee731b09d8cee181d"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b3c5b86d016cbeb4003496c58f97bc9cf1d732f60956396724cb7e60d05970e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41f2bc4ccb70e676a99a387180fc962b99fa73970fb0813134f0f7285520b613"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a50960475ce8b48d9c9506e4ccac4edfa3fc0f67d8f73e037e1a0261df6cd2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "80796599ef149297675cc043d807be66836245ca1f9dd726d98d006643b00abe"
    sha256 cellar: :any_skip_relocation, ventura:       "331d6fe140cae0b5cbe369f4e7025fa3464cd33d4b47a30c95c9516e8c1a8fee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85ac1365037e7971959069f0ddb3ba14b41fc06f88fceb4ea4445dfbb0d3574a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a9d247fc42cffa10dfe8d86a731eb31026569c0e1fc639f4f72a986682a3f5"
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