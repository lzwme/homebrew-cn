class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "7acfcae3c7dce0de840614efb871760074c7df344a96bd71907d71705f5f2d86"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfd0d0e531993d223e1674dc999ae0c350c105f0fabd1323e1ada297c6dd4f51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "548e1eee590f14d992137b1440ecd640a03d0bd21316c942d8afc9ae5bd62673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de4d49bd73618f561f312477821d16717c8cb5be2093a7587a9d1d826087ccef"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d490b1673e6c36c9371abebe8e4be8ac658e9b270b4ddec726c56d397146df6"
    sha256 cellar: :any_skip_relocation, ventura:        "cc81217bd7e51f126571ca71ffcbc8489315b65b4e8afa7410469d20ed77066c"
    sha256 cellar: :any_skip_relocation, monterey:       "422a51146b5f5ae495d96bd4663036cf8b45cb0c6b3324441a12ba32b6ace885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d52bb2500caaaadaecfb1407ef3e8b8f87fd2502c565d437efc91538a0f7786c"
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