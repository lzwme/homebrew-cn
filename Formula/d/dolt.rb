class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "8e5a646d5818e023b66814193a7d1b738522fcef9e4769bdf88d7193e0dfd273"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4682bf7451160851138f0a3848d21d125f1397d39fafb533e89e6ea00c975463"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2ebb7a3e306f91aee610a2493df58b6668b9f8b37103ae656e43cfd3a4f118c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "277a78efd5c000f39a34ead8832139758e037ba292eeb9710c2957cdb3cf3c7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "007b1aaa3de52c5c037fe3a368393b2524d5102c607ea9c5ec812c2ae79e8783"
    sha256 cellar: :any_skip_relocation, ventura:        "56ba2a873c4cf5f570ffa6f696c1ec968895746409af30500ef7440513d30b10"
    sha256 cellar: :any_skip_relocation, monterey:       "733d83428da2e5db60e9fe96cfb4638f199dc4f7e9272609223153a1ece6b033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c15ceefa69a598634c78e450ec560cb7e753135eda0df07334299b36da027274"
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