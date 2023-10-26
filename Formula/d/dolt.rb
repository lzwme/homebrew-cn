class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.21.4.tar.gz"
  sha256 "93e345cb4cf54b8238f3003b13f4bd27d219edadc09e36be3194e5424ddd715f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7611d3a83d2844fc4fd16abdfeda62a63a4d83ac9ffff86dedd7e2ae5cb966fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4ab5bd252e3434e9621b637897367a894e9b21f252a997a16ccb006075b1ea1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d80b759d02120feeb7fb75482e4b800720326ded3c0f4bbc72adcc83d14b6020"
    sha256 cellar: :any_skip_relocation, sonoma:         "c70abcbd8a8ab972257e825f5327d7a1f07ea1adab707bdcfba86fae1c2273d1"
    sha256 cellar: :any_skip_relocation, ventura:        "889b4a54c512d33a902722cb528169a863b59050e7f6b6cedc73e48dc1cfb0cb"
    sha256 cellar: :any_skip_relocation, monterey:       "cf4aaee7dbcd5ea66e37c3953debe79bee0841c31cc238b7467e2eacc7b229ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac23e5fdc765db6d26b8da4b4ad8ccbfba7c27bc870f5403960e9bc0bf73e39e"
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