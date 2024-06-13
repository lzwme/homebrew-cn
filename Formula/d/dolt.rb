class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.39.5.tar.gz"
  sha256 "6a56add77532e068a45f4e54b5ed792ded31d8ce6a4974bbb15f9d5fbf3f4af5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5265034bfc1e64d44c8703040d64268bda93e48769e85a0e558bc8a386b77dac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9c75e26f178feec247a9681be234975032069a9240a824adfd73eaa2a1c8988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57a3f297e28020883d7d62b9cb14b5573fdd991d6a3506e4bcbda2b9aa6f39c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "577e4310a7c075d3b27c68906460a145fbf354ad1cb225ac02f383e2a5ab4eee"
    sha256 cellar: :any_skip_relocation, ventura:        "e08e88a8d57051572f023810662b1289c76e86420c9c21bd2d5e26261c84102b"
    sha256 cellar: :any_skip_relocation, monterey:       "9cfd8be05eaabcfcabb5ea77d1ca554288d5adf63b68aaa15b8d23eafe11abee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c64734a3fd0df4d5099cab0405ae0827b06821cdf676c3ea324c3d05ab786227"
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