class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.27.4.tar.gz"
  sha256 "cf31479006335d158b98551f4f1ccbc2165cddd7e29762edd1f0c533642b49f0"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "917a08529c9c30cd7d3626e0d67ad6b926b5e219e02bbb1e759f16282ed1490b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "172f79cae60c970ba9e2448144ea07f8f6f8e4c3bbaba7fffe4d0d56b82a5352"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbc77a3894c80804b38091e1994330f1b306e800050efafb89b460095bdb75ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "ded8dd4c8bcd60e5274a112fb1f5d1ad5e150771bc0d14c3a385b420a387ba01"
    sha256 cellar: :any_skip_relocation, ventura:        "ff33e8d7fc0bc6462718436cf285f4be87c7213b134b5604d6ef77d5c88b852d"
    sha256 cellar: :any_skip_relocation, monterey:       "6e65b9174820d6ef4fa1e438d59d73a6456eb9738c7c686b580cc3e06910c696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86dfc077e6498817a0570f961c88b0fecce80735c6681b897ea520b04d2b8c05"
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