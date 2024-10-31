class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.10.tar.gz"
  sha256 "03f70573f6c75af01dca708921399a7df7a2609695ce2ea1e5f67bf077d90a8a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58270c97f4b8e5f14c6a9cf6838a3c859b4099e890365139685b0760a70c2d60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef856189cf6c5779574e66fd24eb2f0a37b8ee40993ec2c9a7b0d2cc1e1b3bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2587fcf5620dcff07ffcb23fdedca76b27c3d9136884c777c37053bb77acdb65"
    sha256 cellar: :any_skip_relocation, sonoma:        "515e18f012dc52f8f765e838f4086c00b352fd5745d30ae92bf35705b1cbe00a"
    sha256 cellar: :any_skip_relocation, ventura:       "c927412dd91fb9a98540ebb197f0bb2d9c75088a6712e1ba04558136b15be7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b65fe0a3e2902f84071c15aeb2afd7ac349cb57ac648a87d54c1de2c0b9aee0"
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