class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.39.2.tar.gz"
  sha256 "4001b177afcc32971cc428e8c6e47b6339f291196a431b94499be325f316ecdc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bf77f2000259c96ff7bfd8645a284db332f2920f97cca7aa82ebf79b301a6a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaa9f38282ed44fb1a7b498f07803e1d2cd11e920a290db0c99e97932bfb67b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67794c5e6923b7b3258948839af981db6fdb0bdfe70cb4b9456bfa10a643c5dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "2febc3132e113d4ff0099b5631b753102f598b320e7be482f75be2ce93eb2611"
    sha256 cellar: :any_skip_relocation, ventura:        "8d168f66256d770df26d06467e9f821b9a99f13072328a89ee818c2c036b5cb3"
    sha256 cellar: :any_skip_relocation, monterey:       "214396c03bf4eb277c36ee472672562b9d7e09bc0c066e327789ed6ac25b55ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79f306c0b1eddc96f3626dd24df4bbcdc470b318648136c6ed093535cd3ba994"
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