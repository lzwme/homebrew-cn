class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.0.2.tar.gz"
  sha256 "303441d8a352a583711a0f6723aa3d3af83f7b5c829caf896d2b73e5a7a6a1db"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "493e6684dd6347e5867dc04203d9a84803455e071bb083be9dfc6599ce51baa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "493e6684dd6347e5867dc04203d9a84803455e071bb083be9dfc6599ce51baa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "493e6684dd6347e5867dc04203d9a84803455e071bb083be9dfc6599ce51baa4"
    sha256 cellar: :any_skip_relocation, ventura:        "64b4b364b29a749a86aab60589268d874dd54d08a584d5032d44a071bed942e7"
    sha256 cellar: :any_skip_relocation, monterey:       "64b4b364b29a749a86aab60589268d874dd54d08a584d5032d44a071bed942e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "64b4b364b29a749a86aab60589268d874dd54d08a584d5032d44a071bed942e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e548b07c99313392d7845642c9094029956f49489cabde63f85fe7738d89227e"
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