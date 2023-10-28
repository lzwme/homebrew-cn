class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.21.5.tar.gz"
  sha256 "9a03c110cc53aeb037cdd707eefb6e42cf87fc70446114614b5f11ee26e4e3f5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54f50fba2953feff4a1876e6547d70ffee796cc3f3bd2894e619c64777f2d790"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b512157db24165b178c820ac13ec5e9f93f6e34804d121fe46e0981949772bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0e13c50cbdbca34f9b8c5b1a1795be444948c199562ec30985116caa5ae9b56"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc981314983eb2955a74a6071aeed4a49aaa921ad8cd2802919480ec4c330493"
    sha256 cellar: :any_skip_relocation, ventura:        "3006cab95774f190e4263d6ec569602636e39cb90e0378f19d81665084e5f63e"
    sha256 cellar: :any_skip_relocation, monterey:       "a61aa1f011a6ae0fc7e5ce1688c73035a24c609d129b4a32aba00a0dfd9837e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5fa49103125543b8429bb148959a0a78473eda52bcea8ee168e5c2e0350636"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end