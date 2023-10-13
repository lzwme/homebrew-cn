class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "ba5773bfbdb11dfc82ea7bbf94f8d04db8cfdd82214ffca00dc9ecaffdda5b63"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55bbd82b26ec717d71d52c4631baefb7b3820dfd5ab4dcfe2766543965ad8eff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a757a1406cac7da2f1d7a7f8f952c26bd830dce68dadea0d067d0511a727d463"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aee5c620ecb0ad78f01fd20a93a1135bcad36d34936e72b6e185e0b49bf91bf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "025bd0ad09c756d929a0c55ee0274fb25064a0b8431d9af2a1ec32433ba678bf"
    sha256 cellar: :any_skip_relocation, ventura:        "35327b2d7ca20f719beee917ff86e5a750508bbe0bd2132cb3803ba9329ea3ab"
    sha256 cellar: :any_skip_relocation, monterey:       "50ee65d48ed6bf6b837bb5bab3929a35a0388a7c8102e373c749637cd7abe89f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8281fa66c1e3947db2d157befbd7001113a5b90e23fe6bace931dc2007543593"
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