class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.19.tar.gz"
  sha256 "b38b9b8ea72c2d14bf4d87ae43be37c895d00fb1aefa57d6800f447b58dbc19f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cbd05750691db922661146c4f17682e0a16afe48e1f51619591169c86632360b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38da02904a3b82a85ac81bb1244f3c2caa5dc92c16be6c83dee24cb318230181"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc33744a2461764622b32438089f4df5dcb5b6992e899c9eb5c59052e350309b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a51099f0b87b4196474aece908c0212488a7ee6ac2b37cc0c0dfae357525060"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c6ad15d431e9ea9755599105de018dbd973f6eaf5397b05fd3f642cb1c3a840"
    sha256 cellar: :any_skip_relocation, ventura:        "133d83e8690f1a2fed1fd03aae20fbf421c61ae97d3d3e00df6ad2b764cea183"
    sha256 cellar: :any_skip_relocation, monterey:       "3f66bc6fa93378d5f3e334f98890e16a848e09b7f8f682a27770a86d3fe0223d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed829b45484f684681fc27bd63b052d485cd5ab5e7dd98714fdb5ca6048203c1"
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