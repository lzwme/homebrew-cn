class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.28.1.tar.gz"
  sha256 "edd2904133966026498d59218787e9cb1d510d38e460d16025a073c19784e077"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21bb3e6e553f67c336134ba4db0cdae50bf37b395515439298e9b86e0d485f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15a646e0915226107ca49ab31333b08176f424bb7cb4e46abaebafb758d7ec4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "814c4e95d77b00f13ce003c9189dd95516afc580977a75c4db88fbffddc27d9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b839b070f2f09d54b2d4a68ddc36d0c7fe69dc06fa3190e8bd092bc45e8af51"
    sha256 cellar: :any_skip_relocation, ventura:        "a6bfc3d37f97b920e87b6a5a9ca2e87b57040ac7113483ac0079343600010511"
    sha256 cellar: :any_skip_relocation, monterey:       "712050deb418aff814b61b588b910e462367e8e072e06de0d8c049144ca93567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f378e87c2f684d5792d563ec7d98ff71ae8accfbd43d17cabecd6371e9766249"
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