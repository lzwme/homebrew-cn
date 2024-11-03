class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.11.tar.gz"
  sha256 "64745c10d700de15dac926441400c4d2a9bbfd320b657f9ece49845ef3d6ecf2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "663f43779cf529ca36362474ed273531c2c5242527e2483d0f4112935b42644e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ce8c9389e8ebb2d21543739030962aea1a95b1f78077cacdb58ac561d25930d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce51fac6054de23cd229b8cd63c7e985b9687ae4fc1d6495b8c75e83d984ca9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b185c44901cedd2a55e6212d17a45d3d41bb19d256202b397bab40cb89a8c6b2"
    sha256 cellar: :any_skip_relocation, ventura:       "fbb4caf089428f9c0995e2172098f3a071274dab9c8d590e6a135859f9d1f393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbc464ca5ec4586d6ae944fc3db3a6fe57a6e9f0a2bff7b3e33a61fff6ce7ce0"
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