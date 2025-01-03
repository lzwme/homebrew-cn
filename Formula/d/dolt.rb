class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.45.2.tar.gz"
  sha256 "26a76acbf1e72a4b1e8673d70932910dfc5acd47535e198c7c416b6b1505f923"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd81b0d494876f37bbf4ff4370a8f1733595bed823b8f7495df4c0b4d6d1a86a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90458d705bc2c9d213b7fe9902348d4228a1fbf90b667603edf291c67962f778"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8afa007b9507a9ac5568b21aeab0d354d21379361cd9d063d61cd75f130edb8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0472eaee62cc3d1be536b4070526759f97d72a8cc001b6197973a0d9b6afda6"
    sha256 cellar: :any_skip_relocation, ventura:       "a9f349c7d9e4850c91179a9a08f3f707cb28b08a335add3d701f55b8cf9450f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "474890e93e6f2864e6d17d0857cae03d6e53c9745c434055e9d74065105f9fb1"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin"dolt", "init", "--name", "test", "--email", "test"
      system bin"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}dolt sql -q 'show tables'")
    end
  end
end