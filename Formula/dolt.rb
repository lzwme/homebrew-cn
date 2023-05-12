class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.0.1.tar.gz"
  sha256 "29e5374270fb1620b000fadfd122bfb5194693d81c5b586b80746c381dcb7407"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36c594070e9124783ea907c3728823f2825851538b36dc0e15f8f8151f09a556"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36c594070e9124783ea907c3728823f2825851538b36dc0e15f8f8151f09a556"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36c594070e9124783ea907c3728823f2825851538b36dc0e15f8f8151f09a556"
    sha256 cellar: :any_skip_relocation, ventura:        "6492c3e2761ece5210d6aac8949dfe493c618d5b32c650e8bd318b67358a0f42"
    sha256 cellar: :any_skip_relocation, monterey:       "6492c3e2761ece5210d6aac8949dfe493c618d5b32c650e8bd318b67358a0f42"
    sha256 cellar: :any_skip_relocation, big_sur:        "6492c3e2761ece5210d6aac8949dfe493c618d5b32c650e8bd318b67358a0f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60a83ec00bcbadd311b0966d49046e38aeb28e42ca364404bd32a08075c823c8"
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