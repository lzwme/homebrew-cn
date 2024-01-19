class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.31.3.tar.gz"
  sha256 "3e3d835fd44e67fb9d18ecd1fce99e124d7491e5b1628ae525f820407df3375d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80404f20843fb8c17fa8533f503528afb016b72720898cd7b540cf39ad88166c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93b1afc50c0d80509a23cfa021a32835b3996c3bc1d6ee97a961a9cd4f2cf5fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d872dbfc50d1cb875e8c5ef768362c6d23b7fd0fb730fc0f878f9ffd2af01477"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9506eb88ef9ae075f609c1dec2bc22d2de91e752015b45ad02a1fef7ba405ae"
    sha256 cellar: :any_skip_relocation, ventura:        "8a11560b6df0aa2a17e7f7d67472606e60830fea2e826cfe53d92d4c9f3d0b5d"
    sha256 cellar: :any_skip_relocation, monterey:       "9531760de8d671786e0b17d4a3aaf08eb0af6c55b255cc599da3b4a8a98262fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd969bec197eb08a1d2bd87134170b7227b0360719b26545270c086fa8459a3"
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