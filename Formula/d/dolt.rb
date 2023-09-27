class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.16.4.tar.gz"
  sha256 "a99abea17ca597bdc2de6fb03eae817fcf7f70c7483a6605d034225911ac7ad8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8f52cf36b2e4fb4cbc6283b64af3bae5c44abe28f8d0f808f53fae5d045aac1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f8e23c870d154796c4b9d1b74f848ecbaa3f38eb2421d380e299c779fc84914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1835bf37e1c899aa29666e6b29be9b191f8031f95f9093d5209ba33d0f2883"
    sha256 cellar: :any_skip_relocation, sonoma:         "61e4f0db22ba78fe4799b484f90799d24006127a7faa3e13b5f2434c53fafb71"
    sha256 cellar: :any_skip_relocation, ventura:        "4ae6579e12900184046d881be87585244a321e50cb1151af4e84fbf8724bc42c"
    sha256 cellar: :any_skip_relocation, monterey:       "a8276a25e17006ecc413e60cb34779dfff4c285e21e943b6285060b44b3860b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d9fa4e6a9a03a2fe5b57b9872cbde0abfde21a1f74366b50f0e4cf552d7c991"
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