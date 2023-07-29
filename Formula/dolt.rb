class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.8.6.tar.gz"
  sha256 "53ac0ce093897370d0392427577312e0d1d3c99ac7443f18809471c887f8a246"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0cbdbb2f1a0cf0e1d3a254ae50bde5929aef1fb688322e9c4c13f5e4157a5a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0cbdbb2f1a0cf0e1d3a254ae50bde5929aef1fb688322e9c4c13f5e4157a5a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0cbdbb2f1a0cf0e1d3a254ae50bde5929aef1fb688322e9c4c13f5e4157a5a5"
    sha256 cellar: :any_skip_relocation, ventura:        "e501c8ed8694e227d1db4c443dd0f4d16a65289c80de8469cc4cd93a3034a0bd"
    sha256 cellar: :any_skip_relocation, monterey:       "e501c8ed8694e227d1db4c443dd0f4d16a65289c80de8469cc4cd93a3034a0bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e501c8ed8694e227d1db4c443dd0f4d16a65289c80de8469cc4cd93a3034a0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ba64512520a22bc723141f7bbc6d9942fc3b7346b5e7bad22ffe4908d60b150"
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