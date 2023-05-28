class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.2.1.tar.gz"
  sha256 "e761345b70590d827f0fd31d364441954278383ffc3b812c3eea3d61d6530b01"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d08ca1142ab8a990b0d8d46c977d995cd0aee2b36475e6b818792c97dbe010ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d08ca1142ab8a990b0d8d46c977d995cd0aee2b36475e6b818792c97dbe010ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d08ca1142ab8a990b0d8d46c977d995cd0aee2b36475e6b818792c97dbe010ab"
    sha256 cellar: :any_skip_relocation, ventura:        "12ba6fe27f8713fb7757a73d7635ea4571b3b1e22739737696cc5110a0a63975"
    sha256 cellar: :any_skip_relocation, monterey:       "12ba6fe27f8713fb7757a73d7635ea4571b3b1e22739737696cc5110a0a63975"
    sha256 cellar: :any_skip_relocation, big_sur:        "12ba6fe27f8713fb7757a73d7635ea4571b3b1e22739737696cc5110a0a63975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3c87e1e4a05959b136c4e5d42a7a62fe3bd2985e3488205984bdc657fd017c"
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