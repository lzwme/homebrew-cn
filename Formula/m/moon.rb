class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.26.2.tar.gz"
  sha256 "6d823eaf7ff1c47c4e8d9d1d338646b8792d7204da60639e294988107d602868"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45aca9a01e06822e1a35c9f923f46e77f3f8957d946b8351194de29934ae82d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c74b7f949284853704ce330188d705ac7382e53c7b5dc07aa55d8fa5fa71e186"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91a321eec0472b671a93d19da35402f70bfb0411b351db41e1c3f547de378c0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "46b2c5d70dd231dc3acff264c2e61bfb43f81a49ca1a33485f77a217fb6c7f55"
    sha256 cellar: :any_skip_relocation, ventura:        "0c40c1ff81be074557f2069b3d69a0646d0309ff49451dea11beccb31dd4692f"
    sha256 cellar: :any_skip_relocation, monterey:       "58c3c365ef0714c42f7e7399f2d2928c2e9129184fd66eed7ad2b027a549fef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94dd36eb2cfb06b14dd4ec7e8c1551dbdf5e3ed060c98ce8d09ca6eddb74ed74"
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