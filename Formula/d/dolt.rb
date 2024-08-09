class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.10.tar.gz"
  sha256 "e7438c839958b76b35a5862419ecde3ab20c4dc8943fbdbab2403196f1fe6435"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bd212cf81704826ef3d34b84dfcd7499c5510aab70b9c7ce9da7b84c3e3bdc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cab22336242e95c65ecce81266ec763b4d6861f4e810bcaf767447eb172b7990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d9be8f7ce7dc3a56c993a2de1c92d49abfa5e75cf57b1fd2c189db45dc1127c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e92810f1a6187ee01deb920abb1c429836fa7828f59b3ef69039ae3d5790127"
    sha256 cellar: :any_skip_relocation, ventura:        "0510bf5bbb37d700ab035d480cb695e212a30e43d7e25197d9477034b56147c7"
    sha256 cellar: :any_skip_relocation, monterey:       "aeafd8e641b73a8294ca78728c276f2a880d61b53b314b4e1e8060faa3a4ee3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f60c3423d279fdb764bbab3728d54357fb05da9582c265b046f0c2429e0016d"
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