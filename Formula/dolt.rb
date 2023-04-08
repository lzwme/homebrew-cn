class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v0.75.10.tar.gz"
  sha256 "d97e27a68bf49c3af4380db175b9109e705cc561ee76e91beb603a4eeaa93a72"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e6088e1778929ce0cc10e071d6bfdea8136b2e3375aeafa29c847647d0e7676"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e6088e1778929ce0cc10e071d6bfdea8136b2e3375aeafa29c847647d0e7676"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e6088e1778929ce0cc10e071d6bfdea8136b2e3375aeafa29c847647d0e7676"
    sha256 cellar: :any_skip_relocation, ventura:        "7da5f7e2a343569f98b0980922bc1e2ddf6dfc6d6917c9831e00f71fd0bd9714"
    sha256 cellar: :any_skip_relocation, monterey:       "7da5f7e2a343569f98b0980922bc1e2ddf6dfc6d6917c9831e00f71fd0bd9714"
    sha256 cellar: :any_skip_relocation, big_sur:        "7da5f7e2a343569f98b0980922bc1e2ddf6dfc6d6917c9831e00f71fd0bd9714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994a1227158131054dad96f3ac6281dd297da14f96db60a271858f2afe228f90"
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