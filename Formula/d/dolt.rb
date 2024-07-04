class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.41.2.tar.gz"
  sha256 "86dcb8fb065aec4c237453656d4e9816d1d6112bf3f9553fa9bdacd3be1efd75"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0331ed5113dc3ba4eb82b4ae749d725c860409adb10855e8a023d68d48398fc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "169a42dcc887709442ff7467b682a061a19e26eaebd9eafedea639d697ac49b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c45377cb516577bc460f99d94f0c00e14739615311ded82df1a0da4ad81d3fd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f76379c633200752a6762bf41b8eca5594b6ae0f42e3d91c8dcd2c7df83965dc"
    sha256 cellar: :any_skip_relocation, ventura:        "6d83b184c2160fb83b79538200020b4ccfb0fae542d7ba358c41d7204b75953f"
    sha256 cellar: :any_skip_relocation, monterey:       "987a88f881d76f621243e63479148b320f00ab74c3ebdd931746bfcf4969dbff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2bd4a7a4926a57145229b35f79bb99022047e1e12812ef7cc7228a74c5f9e65"
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