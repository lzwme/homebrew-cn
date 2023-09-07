class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "8247343ae19b77a2a9cf400808714704b49b21debad4eb16e8ebc90268192ea8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51e21c83a0d024ffa3715b50c7fcf5d7f847aa0d2b14c547976e6e5512d2b7d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d7a5808aca82019721caf70c1461991453d96969bdeac84adb7ed17f50d5d1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e56762623f8e65791fa46686d5ab754498776a0de71e0fc694a3a14c02435b37"
    sha256 cellar: :any_skip_relocation, ventura:        "b839aaf70eb0853d92ddc5078c8f4adfe5007a4845995dcf680138206f4e3b99"
    sha256 cellar: :any_skip_relocation, monterey:       "92cd12f1934f93b7b903812b2bacffc533b57a1827b9fe5ebbaa575aaa04df82"
    sha256 cellar: :any_skip_relocation, big_sur:        "f261a1f7ec1822e3a910f22e4bb1bde45e0720f9fd1d0f836eb3163df24b6f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "691c868865e7711debd9463d879b914d6bfde56b1b98d16accd725dfea39cf8d"
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