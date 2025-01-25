class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.31.3.tar.gz"
  sha256 "1dbaa927103560cf67fc1d052333928ec4cb4c908e111427a4afcd864d734adc"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df58c12e71c646abfd792a0dbbb606a51731fe47903392ed4888359323cfbc28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "547f281efae2f643ffd23daa967ed4333428405d4fdfc802c85adcb53f6cf50c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84c0a9427470bfe6f13c1608d0e56f49d8b47a9975af239950b357ddbe2ed150"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2e924d69cb875c4adc21fad8f53965c961ee11cabf023ed37af85f4310b99db"
    sha256 cellar: :any_skip_relocation, ventura:       "d319409233adaa8132e7e7eba7aa1f3bfedd5ac11e573b3b0903d437391f249d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e8b40bded92091e7d4c4624238c9564fd4691a38a26b586d15fe021ab8644fa"
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