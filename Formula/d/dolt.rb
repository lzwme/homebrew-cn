class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.16.5.tar.gz"
  sha256 "64ec1631c0437513a1c5a60b36e92bff87c1316f30cd982ad5fc21c96cab3e27"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35e0011629b9b3c55b87b23a62bf2076660bc2ad797165b6a6dc0bf2722632a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61407181f1425611474af6217d8a10ef0da887b271036bd3e8c914fec62d90ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac412f2dc946938e60503c9e5fd6296b147e263c44615e2b5a98907a34000a83"
    sha256 cellar: :any_skip_relocation, sonoma:         "82403eb235b8a2ad718eea5e5e860d5a7fac2bf6383eacabff9e54d09026771a"
    sha256 cellar: :any_skip_relocation, ventura:        "bb9fa2d5bca6a7b2cc47254e8ce90dfdf72290b6f71aaf37e2df5d7689e249fd"
    sha256 cellar: :any_skip_relocation, monterey:       "bec11691897edbce61a2e5552cebbe64717dbfab3b90ff909a229452e2c9d2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a98d888ecce054f477196c725e25db3375cc1938014c8dea3dad0f8bb3ad4625"
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