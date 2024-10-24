class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.29.3.tar.gz"
  sha256 "1dbeff46df1f72b873c1f75837d0c778076bf295e6e20144542740695f95d2b2"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91993c98ad960fa2db9bade21f7b2e3e1170b1046d5ba8a9550ceb6fd84c7b44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "476798f19a7741d2ffc3819920984b61184912588c90bf62bb552072a49ec6e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1863456c7ff7f9d3342d72ff0c1b1c7c6627193767f1f83986f970988a0d7b1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "573e9abdff93cf975e9ed49061e4ee13264d7a1f8d74b8f93826b53751200dec"
    sha256 cellar: :any_skip_relocation, ventura:       "823ea2b664b5fb826225fda0631512bda0ec0dd9cba0a8351dd1fb465dbc1fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3388c678d5d443a46fd4bd53e9bcb39d1ff87e4b2bd517b0322c17126ee5cf34"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

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
    assert_predicate testpath".moon""workspace.yml", :exist?
  end
end