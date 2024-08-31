class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.17.tar.gz"
  sha256 "05af7a7537fbf4632d249acc4fab472f8ca608e3b0888e9686fe22f05fd1e4a0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ad6f7fe87c28a4420724db05edacf7758e738b5dbb793ce09d1d026440e67ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddd2fe3153f213e9d43aa3414e3ce62ae617c3f598971902666830b92e6232cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a075c731d56425503dcf04551f337f11418054eb6e80a93f2adf29a1c1d7fbaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "9aeb56128900c8a1df3ca2e02e6ab509b5784ff4d303586d76abd08ceb29b87b"
    sha256 cellar: :any_skip_relocation, ventura:        "00b919cb6a13ac0b38f56528148f2b3aa04eb47e3439a48a41d59e714d1f8070"
    sha256 cellar: :any_skip_relocation, monterey:       "c24a645444a3582813529ac6f3fae01167d247579666a9aaa556f065e9126a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a40f7748f40e974200bd8b738e18ac807fdfb10706f120f040a63011d919cf"
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