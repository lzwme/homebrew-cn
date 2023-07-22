class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.8.2.tar.gz"
  sha256 "677f7c25e15cc845c60a4c5f215dfe2ab574138735e8fb5b8f003b78086d07ea"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4f3fba18a3b622592c1b338198e0e1d26e5a8701b90f43a1209e4a0d6481c0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4f3fba18a3b622592c1b338198e0e1d26e5a8701b90f43a1209e4a0d6481c0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4f3fba18a3b622592c1b338198e0e1d26e5a8701b90f43a1209e4a0d6481c0f"
    sha256 cellar: :any_skip_relocation, ventura:        "a22e508ffedf9a9dfbba925b5f4e58b344015cb51019d4396f75d7aa18a29994"
    sha256 cellar: :any_skip_relocation, monterey:       "a22e508ffedf9a9dfbba925b5f4e58b344015cb51019d4396f75d7aa18a29994"
    sha256 cellar: :any_skip_relocation, big_sur:        "a22e508ffedf9a9dfbba925b5f4e58b344015cb51019d4396f75d7aa18a29994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe6a8d18c4e4eaa3648b45ee3aef579988b3d9cad3f000315355bc8fb1fdfe1f"
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