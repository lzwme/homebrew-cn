class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.44.1.tar.gz"
  sha256 "c3abfb309ecba34d5b0770134b0467fb660c47a7147f0e2a2a1670719045ceaf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc310d49531a978b65fa9257605925c4ec78cb4309d39d8db1a0e1ea23b6d8c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a95f4eb78807edb972bdbcd6c03d0daff6aacbc774c60508edbbf755f8c180"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f05b96fdf84518cf863764b8fd5b47f13e1fa37a1eb5311592aa503929d08df"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9a5ea5911e48935e4a3c45d2235547a47b295a4adfa990917c18421a16ec08d"
    sha256 cellar: :any_skip_relocation, ventura:       "d6be538452ba40e8ff4ada5b6cbce60fc63a2fd2984c3b9aaec4ae8c20687a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcee9332ac26cc7d9ec5cc18218f03bb7abc4b6283829e8274968dd1cc7b28c7"
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