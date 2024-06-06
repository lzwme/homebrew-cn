class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.39.3.tar.gz"
  sha256 "aa0451510fbece520849744d54d43570963d81093c09f16f3ce278f5e23d3e2d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9148eff5b37bb06af1596489ab59f24c10bfb5a9250ef76a7fbde32cfe9af14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d961cf6a44d6a895042ce005b20261345791eea00d1fb8ba1551352c2739529a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57697db23bddec27ca1a5395078309e1cec419fa2fcd30471212066d5d32260b"
    sha256 cellar: :any_skip_relocation, sonoma:         "17b7283309281188b9000076974c188021233664d11311baf37b638f1b79689c"
    sha256 cellar: :any_skip_relocation, ventura:        "47cc70e359ee4c5a99ba4c13e4833f49a98d092a87b69af37b47ff6fddc2d59e"
    sha256 cellar: :any_skip_relocation, monterey:       "5459a91bca0a1920b8fd24a15ccc41cefceb12177ce8cc4d695e29aaa6944472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3838c2f088d2083effdb51ed6e8fe0e691adabd885d88da5372cbd5c9097be55"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin"dolt", "init", "--name", "test", "--email", "test"
      system bin"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}dolt sql -q 'show tables'")
    end
  end
end