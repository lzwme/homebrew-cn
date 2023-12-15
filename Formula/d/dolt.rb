class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.29.5.tar.gz"
  sha256 "0fad14394c82c4dccd1863494679183497593270a86aeee4a92e35f0962b0612"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "192f03bacc27eaf6e58459e4e123f09221d28442017ad6a29baea93ed35c2603"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bfe69e727bda8e3c7acfc742ed3b04d6f4cac4934d3c3e513a63896656ea241"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5243c4881fc8257407d9271846fc05fe80bbe62d779b5c11417fbe7db8ed87d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcc6811c3cbab27667180cf2945f827a8877bef5700c9d97969fc72eb9de04a1"
    sha256 cellar: :any_skip_relocation, ventura:        "0ada9fb3a6f9ad9a9523abbd1ed93b83a8a40a5fe4d860726879d83fa5968220"
    sha256 cellar: :any_skip_relocation, monterey:       "c72efb736d688257bc50c6c9f106d220a59b72032b9218d22442263109193d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97f7a655046d1bee2966b283b7882dcd4a52d896e3d70556435900b2b3be20c8"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end