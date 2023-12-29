class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.30.2.tar.gz"
  sha256 "46e5f31a84556e58a2a40de84bf6a3b19a3329df19df52ab244b822a0edfd13d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcacd8b6c17a198b3933a00bdd06cfd635a40b1810a684a1f6c50b14b0c95ec5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f48c4b93ca3d235e4af683330ee369cd12888a067ee63608f0114cbb110c8b09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e46933db4c435f1779a518ded79172cc8c39a7781d1635fe68f51fa1e5c54e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c15d10f103e33567c8e6ce311ffe46b07c00c65140217f74bd8f5e21fea24f7"
    sha256 cellar: :any_skip_relocation, ventura:        "185d2fe064e490492d6f3996dd5ab5dc42bfc10738e13960b16279f01b42f8a1"
    sha256 cellar: :any_skip_relocation, monterey:       "b89c585fb5ff654ed1d7bbbcc5f3cbd4717540405a603ed46a912e1484f0f2b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a5fa474b4f3a3bc8eb233f919efc67ebdc51dd0b4c779fb124646403cabf0b9"
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