class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.2.0.tar.gz"
  sha256 "80898359b4274bd1d53b3a1e85c73cf2c560959838226bc1f7dd7dc4f8d711d2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a163fb5b7d860cb221c45871368e39e916ae100c7b63a584235c0e7ee2f4d6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a163fb5b7d860cb221c45871368e39e916ae100c7b63a584235c0e7ee2f4d6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a163fb5b7d860cb221c45871368e39e916ae100c7b63a584235c0e7ee2f4d6f"
    sha256 cellar: :any_skip_relocation, ventura:        "1ce1d00c3cd5187db865a97559c6d641702223c59a3314ebc56f8723e46e81a8"
    sha256 cellar: :any_skip_relocation, monterey:       "1ce1d00c3cd5187db865a97559c6d641702223c59a3314ebc56f8723e46e81a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ce1d00c3cd5187db865a97559c6d641702223c59a3314ebc56f8723e46e81a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc15121ad6df6bc6504b2bbee2b9006711155b677d2bd32624b944a1b9aa238"
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