class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v0.75.9.tar.gz"
  sha256 "615e0946b97fd8a51f35e27198d33b32b2bd1c9d75b3c4cb4eeae5f27ccf0100"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc25e6b0802ce3f92793722c4328980910488a0b3ff3a85b95f39dd765c35bd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc25e6b0802ce3f92793722c4328980910488a0b3ff3a85b95f39dd765c35bd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc25e6b0802ce3f92793722c4328980910488a0b3ff3a85b95f39dd765c35bd6"
    sha256 cellar: :any_skip_relocation, ventura:        "15570f76083ea823aa83ed7aa7edeaff043e1860979f68bfde21e25a8ece1c15"
    sha256 cellar: :any_skip_relocation, monterey:       "15570f76083ea823aa83ed7aa7edeaff043e1860979f68bfde21e25a8ece1c15"
    sha256 cellar: :any_skip_relocation, big_sur:        "15570f76083ea823aa83ed7aa7edeaff043e1860979f68bfde21e25a8ece1c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03d0f238fd6709a1e82935066eae55e60cdaebed03ab5676a63a35f9d6f4c806"
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