class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.35.13.tar.gz"
  sha256 "e4daa021b1789466f1e4043ef3ead95f0ee220e8ac25788609ed3efd7d9023a5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c8b0644f526647e7a24a7f233e680cc6b06a786bb8bb2b985ab59c220aeb1f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6aa8ba0821b1b4488e4b66047afa8db9049c5ab0bda8732c7d4a717fd273708f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5522cf04ccdf59eab7244397f7e53b59d53f9ba158761ad0d0fcb6ccce0b688e"
    sha256 cellar: :any_skip_relocation, sonoma:         "577cb8720763ec08f0f953de9c1eb2c86a9614bdb281e37788a420077b031f48"
    sha256 cellar: :any_skip_relocation, ventura:        "32fbb64c0ad883a68a468560d077c4b40753d5888b33de9180de29f4b223c8ae"
    sha256 cellar: :any_skip_relocation, monterey:       "6782f70b715ffa700ca66798d52e33021ae96129d0fa5ed148ee7ec36221c52a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e263d4323ceacadd091ca45ad8b8f21530579347a2006ea6f8617306616cc1e"
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