class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.7.tar.gz"
  sha256 "8b2439abec211a6b1972c498216e0ce4f8949a9e43a4a60a75cbcef2326b3b0b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df2ea4fd953b079039fd6bd8c32fc5c26199b888536d6ff12510009aa81c7984"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "351610dde9caea56fa19a8f037190a30be462aad79647d0ffef8ef90c87116f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a73666338703be308f3feb9440ed3611021d4a2a19b295c8ee465580f7fb2592"
    sha256 cellar: :any_skip_relocation, sonoma:         "b97bde6d9bdb27a2703ee7a778d32554e1aaffb52b5bcf2556fcd3b36631ef60"
    sha256 cellar: :any_skip_relocation, ventura:        "4add8dc6ed05552aa88ab3936f5bd0f021588dc39025bfe0309a1a795af0e40b"
    sha256 cellar: :any_skip_relocation, monterey:       "c63b83d310afc27c7196022e7b181ddc478f3f10b3955d2a380515979799da57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21e68cd49dd2c9c0483f66026f74e6a3683d7de56ea8cbf1e5fe8e0d70e54051"
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