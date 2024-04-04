class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.35.7.tar.gz"
  sha256 "b21bc7224f3c32b68de590cb20a589cff43c7f4c66e5ad76b1065c3b7e98c898"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abdb3f94d7d67d81261e74788d5de9ca4d8c8a43bf06677ca0d5cd0b09d02534"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ed1d3663642c3cdc1ba64963b641b1bb1f7e17fa4bf3a0a8a34fe62e0f5b604"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a1d4a7ebf5c1346e5b33b4bdfad8ec4d3e0d211c1bfaca3aeeb04bdaca385c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cab54dbe223004594836ed027613c83fdafbee7e013ef55c43f4ba720c6d0fa"
    sha256 cellar: :any_skip_relocation, ventura:        "d4f55c3600763c0298ff7ab6eacbc09e351bd0a756bcd81a0b12e3875a977167"
    sha256 cellar: :any_skip_relocation, monterey:       "2d01a75047289cc78740b33c2a7eaa41c78f9b3fda532ec35656c68481bfc879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cecf10a0255b3449f941e380a41f7f36859478e7444419c5375575f5a3cc1554"
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