class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.15.tar.gz"
  sha256 "1b68d7323df56779e2e808f2ee43572af643014147dbeb6e3341f3911819d110"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22d4f73be63cf3aa6a73d6fac6684d38bcbe5a2bac0a4789d0fba624ff28f964"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1090d767275c7228db56b5d002ef6edcfc5d79782730495abd88cf2ea912bc5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3e9f043d26e19c0c55f5e5c77bef396431ea0bf5074c692232897e4ffd5c34b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4804e58aeca2883c7a47a484a7e55a4a234724307dfc8287e6d5c1eb1ad14e8"
    sha256 cellar: :any_skip_relocation, ventura:        "043a533efa1320b3917778eac5917b65b20d747dcf626e6cefdee1f8c49c18d6"
    sha256 cellar: :any_skip_relocation, monterey:       "e06297c1bb628bce41379d95384f64153ca2db29b89294b5f9382eb605e38f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1243eb77bb5c41e2e4d1b1a36b257e35abebcce25ec89e88655a0b70d2ae09f6"
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