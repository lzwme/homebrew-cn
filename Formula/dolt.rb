class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.6.0.tar.gz"
  sha256 "c948fee8623189ca2319f13d2fe03d19328a0edb9908238cee3c6a39c0c4a7dc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5e57db5d74adcf6d07a7647f7de11e8919c9bbd267b6da5e2a49f17c9e66138"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5e57db5d74adcf6d07a7647f7de11e8919c9bbd267b6da5e2a49f17c9e66138"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5e57db5d74adcf6d07a7647f7de11e8919c9bbd267b6da5e2a49f17c9e66138"
    sha256 cellar: :any_skip_relocation, ventura:        "abbede361c226aff80052a7139979debb26cca8100ccd422f810da44e6b563b4"
    sha256 cellar: :any_skip_relocation, monterey:       "abbede361c226aff80052a7139979debb26cca8100ccd422f810da44e6b563b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "abbede361c226aff80052a7139979debb26cca8100ccd422f810da44e6b563b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50fd013ad3eff89df42cc424dbe1e6857db0b0eeaa60651fd452b2f19392974d"
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