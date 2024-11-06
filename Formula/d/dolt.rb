class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.12.tar.gz"
  sha256 "2eefa05cb470d5cab616c93ad855ba0329f221bb2ecb1b9677a0e7ccbc9ad2da"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a9d9dac875e6b2e050ee77a0963ae9b92258929319ed37eb05d674e85af8e4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8ee2f17e884d7dfc25e6fe4cfe8b96912f50621e7ee4d5f339fff176342ab82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffa9fbc2f5bd93310a69c894f8911f3e429eb69dba99fa61183673d024aaa56b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e09f41a174809bbbb165fd4f3829ee26cae98a71a6997bbe47946d7b26bcf68b"
    sha256 cellar: :any_skip_relocation, ventura:       "bd7ffb2e3815f37b642c409843f5220fb13b0dfa4f96eb6d041db4ad4267e519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c99f65270b823b8500dcffc3949deae02c9683bcbca7adb6b6eb696dec878a94"
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