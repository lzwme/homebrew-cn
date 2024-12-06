class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.20.tar.gz"
  sha256 "bc611825fe0963820e99d6fe798b9f19442ec7806c742841d96abd9a1a71f839"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e645aab14fa8213288a5bb366f7f4c8d34ec1d4177cc6a7df0abed60f50322e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e65c0eae7cafb554def7f2cdb489249bee7187a53db2fe9ba27adf1546d66125"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "083910393f30c8e274b75a66513406149180f64095a55ff2c130ad4e2b05face"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7fc70ba4c0f701fad33f13c3ad72ca92260a3d31914659c5c79c32efa9c7fa7"
    sha256 cellar: :any_skip_relocation, ventura:       "21e389ed24be712ab4ad46653b750abd3c78fc131d70b5fc287de361224c7f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38ea203e633c659ff0c393931bc75a790d4193c718eaa1b504922b89eba3c7ed"
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