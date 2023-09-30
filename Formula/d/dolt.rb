class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "07694c3362bdf2d52655ece73f5b8c3d85cba96533852e54acc36e352c17230f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa57e8a9c3236f3d1c595551f3341facae8febd4707d9071622a8e0d421b0589"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77ca0ab8e4a4737e52dc0512460c050882f6e127e8db409a05a06531968490e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c1d6dbd192c88970919d542defa5771bed1dec01f09faf69d4575fc1c374b9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "47d13e28de36b1dd8ef4f09c9b0a4fdae4ff26c18e0ff4fff38178153f89835c"
    sha256 cellar: :any_skip_relocation, ventura:        "7dd9fcc2c734352c4cf3cb7f30077ca44b7366fd9d797c860030dff3de5c48ac"
    sha256 cellar: :any_skip_relocation, monterey:       "d5781e6489df7915943e23a924500567430c8a7de4ac9fa4b500c93098817b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ba11b239386030e260d03cd510c516bfb3273139000664d2ca3d57db824195c"
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