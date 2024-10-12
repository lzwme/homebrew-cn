class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.4.tar.gz"
  sha256 "eee081aa01a3f16e074a0c54cd720a1e665e9204c325f3d7cdc72fca8b795665"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60b302ed5cd256b13ec23005e298ee65c9c0a5deb13b979d8e9189cd50a9d917"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47e53f8f781d96cf41b2111a39714286f7f7034f0b4efef21c3fa73a99172759"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3434b3c33ebcb47d22c4a455b7db1a5f6695242cc646a0018be069ab366dc6dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "475d42e465b6d6e18c3c54352d4b1f848e0bf6dfb93bad9bf4a3d96e83bee6d9"
    sha256 cellar: :any_skip_relocation, ventura:       "14d4420b4d340940e2816170dabc2aa8563296b9e28f380dff5b6092f43dbe41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5180ce904ee76874fb90761ee90afdcfe5df62a1eb57286a5b00959b338b4c1a"
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