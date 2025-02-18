class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.49.2.tar.gz"
  sha256 "0e2354b5051788cc36a76bcac0880f3a33a48b89598d6af2cc197737f4c9c415"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661068c731d7ac41d31438207ff57795b7917ea3910fd7d24499b8f67ece0808"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfecb60a832bb233ff6fe62371f7e14de49a8e08f66d787124c0ca7b346c6b88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7c9a6eca413b1ae809bbdc1765cc373d800b430bef4e7ad6a96e72a7244cce6"
    sha256 cellar: :any_skip_relocation, sonoma:        "283f6c15c68b73083fcf960e88eb0b3f10f5c031f5932f02b3a924695f2c1a5c"
    sha256 cellar: :any_skip_relocation, ventura:       "b1c057c88a5a518b326e9a25a0892a506d73142e87815463b534a5559bd99f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca62aa8f06cb358d1fab79a1841d16943d5c9975757adb795a384ce0e978f5d"
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