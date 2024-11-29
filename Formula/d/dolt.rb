class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.18.tar.gz"
  sha256 "b35a178c7016ca085541999cedc6341b4bfdb70476a75dbaf518da5d820627b8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d226ca718c173a2a65eb242872f3afdf713e2a58c4adb42ba3f7bf9fcf75e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8698c113ab01240230af3fdde005bb023f10995dd4a2d53967ef9363886397ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ee51a9099fc95aa270d35fe3f1d0198ef9fe8cb3e75f6c6ef2c5edad3a37650"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6ceb93b061300d605a8b270c9c99634b78243eb627607014b91d86dc57de62d"
    sha256 cellar: :any_skip_relocation, ventura:       "9d16c254474403af9e72ca3b02881aa911b45d772b9669556efa2308f8e21a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dab71ed2402c14cdb66234cf4f11589ef025b621458e473b3728f222d3fa2a6"
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