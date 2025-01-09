class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.45.3.tar.gz"
  sha256 "127124ceb038fa500934bff02bfe41edd4e3013ae27c555378b8fb15952b8697"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f637349029780960e7c3fd25d2ea71bdfd912472edae32a37d2d96f2b6eb72de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8502b7ea865d341cfc8a55561f7fc15d0cf73bf3cfcd428bf551cb304309ecc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20a214c6019e873b0843c6351354fc44faf69a7a6693f27f0a0f44ff8af7c457"
    sha256 cellar: :any_skip_relocation, sonoma:        "caab6bf4dcce6cf9c742d5ecb2a9dd5751b9c1ff498159492bdde6ea677d82b4"
    sha256 cellar: :any_skip_relocation, ventura:       "9f629d392daef7f9dc62ca35d884ad27138c113493cc6aaaba07e6a88cbb874b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d0090b42f27bec620248d95dee226b3992eb57c52825ff0bc29e099e7c2274"
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