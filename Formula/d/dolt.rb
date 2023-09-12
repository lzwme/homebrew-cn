class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "b0a5ff4f73c178a35a92ac4f81d17ee1ebd8f8cfb6e37c24daf0ba28fb017558"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9e6bf2213b2413b554ea131851ea0a92215c6cfcb586c9f9aed7ffd535a3289"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e8093c8cf4951fd2844eb164ee1562da25c25057236808faac9a1db58e46632"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b97c54c03082a14d7ba64d7b8b3a5b5d6ecd070ce6dc7b2341df1fd64fa205c"
    sha256 cellar: :any_skip_relocation, ventura:        "7a297e5f39f5260cad50f2ca8f59f5222128ae4d1cb7ae30b7690d4f9baca751"
    sha256 cellar: :any_skip_relocation, monterey:       "6c15d95541d62df03a3cabe1bedd8246d51af4db5d490d30a57533a402e70f8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "33b542fc6b6bb12749fe6d0cec69c4260081025f3ea540e3cc1d6b8325f7f729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b898ef56675da40da1986c9a05df863a815aab229e33abbe15f26338f334ea6"
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