class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.11.1.tar.gz"
  sha256 "49703f4b50e73f19774e14700f9de18ee2795226348c080894e013a583e61872"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e2df9c89980f5ed8f01fee7bb3476a0aa981129eec2ba8883e299663c0590dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fef3930ef3820474464369d2f63dec292f6a8f8f85b75aa50732306c2c94411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47082a1d285e86efd76dbdd7617ec3846a384972fe8700351e94e2f3d1b466ad"
    sha256 cellar: :any_skip_relocation, ventura:        "7fbccfbd752f8482e7c37959db59d0f395397ff9eade7084ec4bd3458b92c064"
    sha256 cellar: :any_skip_relocation, monterey:       "5344983d85376ee39dc98e36c0c27887f8ab3a8882b48fc19f85953ed2936a07"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb2e6e3e2b98d3fdd58118e8d588e006c3fbe21a2e1b4beed72215e64c052f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac52d48dcee11433b3ba7f3b538d0a82cd18d8c8251b6d5f04ed1e7a40617ea"
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