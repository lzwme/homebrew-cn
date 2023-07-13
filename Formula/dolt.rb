class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.7.5.tar.gz"
  sha256 "1d9d01cd5509c8a302a9eed35375447349863a030560b7892e0a42bd36005002"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f4266de58c8ae04bc15d9cee24abe9d1171f4e56e26726212fb8294dfe53090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f4266de58c8ae04bc15d9cee24abe9d1171f4e56e26726212fb8294dfe53090"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f4266de58c8ae04bc15d9cee24abe9d1171f4e56e26726212fb8294dfe53090"
    sha256 cellar: :any_skip_relocation, ventura:        "542047504732c8f343b28ade4bf1d4ce15a84d1e06881b09ad851eb64ff01357"
    sha256 cellar: :any_skip_relocation, monterey:       "542047504732c8f343b28ade4bf1d4ce15a84d1e06881b09ad851eb64ff01357"
    sha256 cellar: :any_skip_relocation, big_sur:        "542047504732c8f343b28ade4bf1d4ce15a84d1e06881b09ad851eb64ff01357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07848502a64de5aaad1c2bba668b022991f2bd3e1fb9f5c205de9c1e18f26211"
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