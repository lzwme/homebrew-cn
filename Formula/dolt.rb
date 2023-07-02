class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.7.2.tar.gz"
  sha256 "233c79851c813bb6e3d8f908628264f38bc782b3cb78372e58e8bf6fe9c93921"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d24db1bf17ae0d4c9c9364950fcbc8c5a47166cabca77ec742ae412a4ac41e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d24db1bf17ae0d4c9c9364950fcbc8c5a47166cabca77ec742ae412a4ac41e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d24db1bf17ae0d4c9c9364950fcbc8c5a47166cabca77ec742ae412a4ac41e2"
    sha256 cellar: :any_skip_relocation, ventura:        "018ded9bcd4f0933ecc1452b15c04b628c31d1693fbd9aa2e5d42106bf13bb15"
    sha256 cellar: :any_skip_relocation, monterey:       "018ded9bcd4f0933ecc1452b15c04b628c31d1693fbd9aa2e5d42106bf13bb15"
    sha256 cellar: :any_skip_relocation, big_sur:        "018ded9bcd4f0933ecc1452b15c04b628c31d1693fbd9aa2e5d42106bf13bb15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba0a045e1fbe3e095ed33b8fac5119f1a2dc3be624fef4e5198166b24ad3914"
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