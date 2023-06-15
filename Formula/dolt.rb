class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.4.1.tar.gz"
  sha256 "c33dc6e848e0514b64cf3f3d7e5ab1ef6f5b220d761949eb4829224bf2102d2f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5e2878f9de92e8bc2254c1ec27092687b2cdb01e71a21f3229b41102ff7b74f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5e2878f9de92e8bc2254c1ec27092687b2cdb01e71a21f3229b41102ff7b74f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5e2878f9de92e8bc2254c1ec27092687b2cdb01e71a21f3229b41102ff7b74f"
    sha256 cellar: :any_skip_relocation, ventura:        "6bfcb6d0ccecb70386c27639bbc4b6cfe029d3334cb81014f3c00f5e6c468675"
    sha256 cellar: :any_skip_relocation, monterey:       "6bfcb6d0ccecb70386c27639bbc4b6cfe029d3334cb81014f3c00f5e6c468675"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bfcb6d0ccecb70386c27639bbc4b6cfe029d3334cb81014f3c00f5e6c468675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d180261445c6d264b5c9c3868b47194a5d02524eac363225f98e42b2b1ff08e"
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