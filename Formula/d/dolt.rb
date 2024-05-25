class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.39.1.tar.gz"
  sha256 "90101700b18cd4af781e359605b44b97413a53a5af70154e6d2a38ad6e0ac042"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06cebe76044028d6ede5057b3555eaa298e77cb3aeb3d3c31efe78013c705524"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70f77b8fda8adffc1402f9467d21f5100aff90b4be99a5c8e4c429ef7c4ff8b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2247931c72a8fa8a09139d32a514115b0b39d60804a9ace52aeab9b16a94845"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d51d0c4ae6a0041d69eb4e6351158465d90f734923e0583253129a55f5ef89f"
    sha256 cellar: :any_skip_relocation, ventura:        "d7bfb5ca9a28c9638a52ee0f75c4b52ad9af496f7ec8167e5378eabc16cbde7e"
    sha256 cellar: :any_skip_relocation, monterey:       "7187082a4fe35cdabd65a5336fe99ddd9b9d25d3c3d6eea6329b100781d2e02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09049d77259d1458ce190e976041a57dd34f3265f68cde23e6c7a05b8fa1908b"
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