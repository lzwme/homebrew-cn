class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.27.10.tar.gz"
  sha256 "6ee20bc4a59cf4fd4e7a1e4d544843bd013c3c17a157380f61a834b7e5c6b31e"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ca9f98519d5301bf014cda28d7b7d1eb1228fc0df3d9f517840a5d05ca7b130"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36413880afdb65f900efa6205f37f67172f0d9a9da8a12fe8970fafbe6324051"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f25968da6402511b9e5ee8712c91aa3c41a7590f26ef58a85c2215e6b63aadc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "210c1105f3af915dff62ff16eaf4ac2886949197a43de09cc3b97a713c2423a1"
    sha256 cellar: :any_skip_relocation, ventura:        "8215ea43b90ec3720b118285ed1bb94cafb669316538e8a7376662d53bf16d30"
    sha256 cellar: :any_skip_relocation, monterey:       "9bee88bb7d86a023aa876d94b860854e48f695052a403585c2809a20c76cda88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61394507fa66b48994d5f6e452e91701edc45364ec2d245f67c94c3a855d079"
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