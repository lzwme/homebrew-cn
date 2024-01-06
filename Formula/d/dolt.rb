class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.30.7.tar.gz"
  sha256 "51242af36263379a90567d1c1fe581ada4a268e0057859059d8254fef3585b81"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a865e2523f00ebd874865abe93c382977d09811073cfe2a711d9a05afb104eb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b92b82892ad94977ce5847fe8db5c4d22a9a63a1c8cfdb35d9328606bf005200"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ff3e7d244b2e978732547e8f28132e7e93603fc37949f208218b67d328dc4b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f11ee319c06c4be5321c2ab8b4cb03135ad10dffc362c44a064965a88fd7efda"
    sha256 cellar: :any_skip_relocation, ventura:        "036744c812db0296db2e15be8aef1acb57fc4b5feec58f9439f2fa96128a4eb7"
    sha256 cellar: :any_skip_relocation, monterey:       "33ed14f9d166a8e8a66b7009adf50fc22b289daea82c0305d4fc4494277ca18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c31801e222e4be10c3ff2dcb33d8cb42a2c9b35943a450a5c47f49f75518e7d"
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