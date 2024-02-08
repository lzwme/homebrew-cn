class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.33.0.tar.gz"
  sha256 "1c02ae4756bf814edcf9a592fcfec1610e129dca57b2b2e8d15a83fae2081871"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a2eb27c335a6d5d48178c3b3420aabcb9e1f68a404b55d5848b3aea9346693b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df8a5c62cd421b236c81811adda47378c11bc04b745868805c177cd78c9605ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "809e9cba870a50658559ebf888d4a73a08babf04902c080df6e17cc11adc9204"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4538ff61d526ede33c797c67b94099770c89c86584aaef164e86270418b7203"
    sha256 cellar: :any_skip_relocation, ventura:        "b018a4203c83be98b380a10b9ad7a290b99dcfbe40638db19b755ef705ff766b"
    sha256 cellar: :any_skip_relocation, monterey:       "14436e290f29d6ae1366370519292360310f6bbe43e3bf98d125a242a3e1f86b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47996c75d45d3e41304cfc0917fc77774e9484d3589490a4cef1daee1fc8c227"
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