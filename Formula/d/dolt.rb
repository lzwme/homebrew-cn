class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.0.tar.gz"
  sha256 "a684f9f0783d58a1a334cee082e73ce9e42acf9ddcac89744ca1f8f932124d2e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b7c3268a576985afd12c167e28749073e139077d03e6c5bd5868c9201a012c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d680b82b961b689f2d22dbd94d93a1ecf8faff1d831317f4fd431945077f2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "592e6e65a875569d185e0ec2936ec6ffa6cd26923d12fcfcd38ed923c9e4995d"
    sha256 cellar: :any_skip_relocation, sonoma:         "54a388b3b89fec871be3cf33040e9cb92b0b27b260ff6020e981233dd8283172"
    sha256 cellar: :any_skip_relocation, ventura:        "bb0b86843f44dd9fe605518c3f2e2afb145ea032004d23249db677e8ba4c9c74"
    sha256 cellar: :any_skip_relocation, monterey:       "c24bfcf58a5a9487a861dd20ee1540498b9bc3e652dac012697f8dfce9f72723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fcfa59dc4b19e85a07eab8197e14472330fdd4453f676ef5bdd2556efff934c"
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