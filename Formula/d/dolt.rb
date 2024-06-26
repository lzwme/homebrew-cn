class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.41.1.tar.gz"
  sha256 "de861b3b674161b1400855e0b67a26d2374942f4da061c2d28dbba573a89ccdd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85226b6c0923161c751f58435d1f22736c0cdcc561bcff282c8b761a96531627"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "347221f3a9101b8e70b48af143e11e54d2e81b1088cc299e6387442d4db13608"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8389050053babad96010139f308420017cde8206a6e76b51e21c85d0b62ad3ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae3046d879973c3217e2fbb5ee7f48c05c22675bb5c0bafcfc0675764c8b6ed2"
    sha256 cellar: :any_skip_relocation, ventura:        "1e445d427489a2c5297f0e80b74ee1dc988ffd5feb10da5e110c676566ae7759"
    sha256 cellar: :any_skip_relocation, monterey:       "8a7cb9f5d708053ac93036159aef42f95d2c5e1c5d91e75183efb7547b478b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3f1ddf2b01bf9cfa6a09f0d9b9ed83ce7d3ae7e3d2f69c5c77e9ff0c3c34e34"
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