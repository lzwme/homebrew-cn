class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.20.tar.gz"
  sha256 "98bb033d83f13177574de6803e15fbdac286bd2c9f7ae76c21e29f57434e21fb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e716aa517b8347d393aa92f6a728a905efe5e438a4a4beee3fb14f326fbddf99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9938316d4938b5b53d005ba1078f5a698daa1347afb5bf98fd2da7dcd8ffb876"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98c99ead4d2e3d12c601dfd9eae0aeca691a7f44b5fcc71adf64f37b370203d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "92ad24d3f9e8f81d93dc0dc6096ba30c4dbeaaabd4cf9ec037c3ef390ae7522e"
    sha256 cellar: :any_skip_relocation, ventura:       "ac5a2fb4d02cc75c0793c0a21382c22f779138c3432b612d7da6b21ae3b6468b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19ca1b18772bfb94d40b26e4356c738f8e01d09d554824c97567c4090d4192c9"
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