class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "1d605425fd0e70822eec836221835ad776a91a92c9cd4d784c4178b776b11a71"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78386a9a3a1cf0a789de72a8bac9c30df8a78319c521f25cae72f37536b57028"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4495ab127c0d4dade0585ca4cfc3271b8d78d751b29987f17deec9315bc7dd63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "396039515d02e6e3f9b8a3065b9c60cf1378e9d5945086867f70e83271bbd5c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e56c1ff4eb98607362bf7eadc62b5917f20afecc5bd2df0b6f6efc4c2e17229"
    sha256 cellar: :any_skip_relocation, ventura:        "a7b1dfb667ba5f9096631e048709c15ecf10781390f9d113c9764096dc6025e9"
    sha256 cellar: :any_skip_relocation, monterey:       "06977829a8a6b4d435bdbcf87f727dab8ac2e8181364d975af9e4832b78c8e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f650afd8c55a5d5a5977276b1fc24ff3a32dbb43025cce948b8b595f996d01a"
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