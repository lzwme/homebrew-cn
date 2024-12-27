class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.45.1.tar.gz"
  sha256 "5dd2c43687de4fe10abc3778c5284a3e78393ad1da781f9418f2f1f38e101874"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d497214baae4f785533a7757c7eee2ac0d63ddb102b2f2372334950139111842"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "435b8d8bb7f6c95cd7037605a05d65691ccff01304e3521579c1268f9af3a6db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de5480fa0b895d1b266a2d504d61d952d969f943a08078dbac24ddcacb830c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cf98f6de02ef58ceb8385d57ce517aca8795a71f504667566850125706cfc9b"
    sha256 cellar: :any_skip_relocation, ventura:       "4614e64c81195234d9b3bf7b81882c396f100ea9970a5328ae9f514f278bd022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcbc1757c715a7939b25b0eb7170a0418661566dfe626550f346487307409403"
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