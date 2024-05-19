class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.38.1.tar.gz"
  sha256 "e3268a80f726e3e3072b25f1870d09adae8624844bc5ee83445f52d81e505043"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfffca3ebd61940b11c8b5f5e32dc9ebfc6b9a0ea6c471b5ca51a61b46db8bcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a497dd6192c1aa05e19d94edc761286a2ac70b17b65b2d3fb6228f8643c1efa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6d55957f708ee1dd6415690f4fb53a3f898c92844fa901cda2da990235d5708"
    sha256 cellar: :any_skip_relocation, sonoma:         "33bd2236d43307577a4a71cdf128a8184e0c319838e14c752a8427cd837e9243"
    sha256 cellar: :any_skip_relocation, ventura:        "7b9418feab282863bdb1c3112cb09837540be39d9e28addc7e46099b4da16f9a"
    sha256 cellar: :any_skip_relocation, monterey:       "c5764f9514b12572d487d449ff78c0507ab735832a07854f67b67d7f9eeb349f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4924b7a229379ab33acc82ff79b69c8e144c9e049c3227b29cef82786a4ceb0b"
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