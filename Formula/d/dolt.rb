class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.49.1.tar.gz"
  sha256 "74ffc18ff901c65c9804bfffa2b5750ea340e66500aa36ab5807bf0c31a06b39"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85ce8bfde46d1770c5dafe569509f45b2c85c3b33fd1eb50396b3accd29766ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d2325608db8f882dd2a7684042a0576a33ff25662dcc57e5315c98776c90dc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26ce01f4f5696c1243e611fda191a8931fbd0bad8593682f73e0fd074dd50979"
    sha256 cellar: :any_skip_relocation, sonoma:        "3869bd23505fa4e7e2e970bb9e30d0a880771811d2ee4a07947045833af01f4f"
    sha256 cellar: :any_skip_relocation, ventura:       "aaedf8e4b9e2ba685764372d3d1e514b8e926eae02b2b1f73d7ff7dc3d9dbfdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650d8bcf8027bb62e64d09641591c18a2f32c2398b46650cee0d7771090aabec"
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