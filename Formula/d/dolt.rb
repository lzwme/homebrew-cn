class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.50.5.tar.gz"
  sha256 "83abb029926f333d31b5086f69eb4f2f8769027d81d54ddcfb50fd696eb54370"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4b9e0017839871c296f6a7936b7005bb6007a489758ac171d08efabc417f65e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9c994e2f86d63236a70d575942f8a44b0c2fd22d2c4c76beb9da5e315c5e140"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbac02869a5992191de28c57d1021823d708cc6deabc37781fb486dfd36beff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a477ef26d367f245f14a9c09eb21384418c23c4b2cd48f064c1f2c6f6c8b56d"
    sha256 cellar: :any_skip_relocation, ventura:       "732d30a0b9cf02ecbc434d856fd5b2c185b7635fd69108e00777965525e0a22d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdcb8ddc8c81faf77eada120d2c74708c6914d02ebd2f74505767248fd6127d5"
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