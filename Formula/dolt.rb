class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v0.75.16.tar.gz"
  sha256 "f84ba48d4c1a670ad797aa5e915faf8b3134f5ba7ccba57ff9326980c31831ce"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f1a5065292e05d60949c42ed104ef5812038e2e16d14c15c1f9e56cbc7eaa1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f1a5065292e05d60949c42ed104ef5812038e2e16d14c15c1f9e56cbc7eaa1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f1a5065292e05d60949c42ed104ef5812038e2e16d14c15c1f9e56cbc7eaa1b"
    sha256 cellar: :any_skip_relocation, ventura:        "e027aefc542dc5dafe6238517b89285e267ae4cc586114c010635cd7add6f767"
    sha256 cellar: :any_skip_relocation, monterey:       "e027aefc542dc5dafe6238517b89285e267ae4cc586114c010635cd7add6f767"
    sha256 cellar: :any_skip_relocation, big_sur:        "e027aefc542dc5dafe6238517b89285e267ae4cc586114c010635cd7add6f767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b84d1cc65534d4e883ed8cc4309ec66e678439eebd2838ac73b09f1c2da8da4"
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