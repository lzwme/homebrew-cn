class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.16.tar.gz"
  sha256 "a77fb4cf84bf198250642d1350cc4cbb63562884d729e97785bc0c65a32f2e41"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9f054c37f072eed9a076ac6748ffc3aabbc3231d783ec2a3b9738b6c66bcc37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b677774c1d7be8c0cc7ebb2b0c4b94b0083fc9454a2e6731e7359e88797482d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9604676be801ae9f58b9192776c2c0186c9983fcb83386b332a73ed1eb1cf1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6ac62f09915c5909880f88c8ad3c0e4e4c82722017ea2f879ba6016ce531ad6"
    sha256 cellar: :any_skip_relocation, ventura:        "e4ae372602d8c249eb61f65dd1d0013844ecb985e8e4ea3b7a16860563be4a92"
    sha256 cellar: :any_skip_relocation, monterey:       "a2c58e6218488c95af7f36d7981f4b11a69d9cc5700b5c7aa825a5b101ef595a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba74dd72273abeaaf95fbdc8ca8fdae55006b23a3f0c69fb15db0fb3e54929cd"
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