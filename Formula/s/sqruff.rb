class Sqruff < Formula
  desc "Fast SQL formatterlinter"
  homepage "https:github.comquarylabssqruff"
  url "https:github.comquarylabssqruffarchiverefstagsv0.27.0.tar.gz"
  sha256 "eca6f294ed6f8f9f59c992a4e5803dd7a18430959cc3647f117c21ffcf969810"
  license "Apache-2.0"
  head "https:github.comquarylabssqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06aa43cd72c7a547d5b99bb89b8cf71bbbcef40583229e17d381c24a81460db7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12d16d87bff5b28c226a364723131772109773b2d0e612df0d1f705081ccf4d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4200dfa79fa68db910aa5ea932f57cf84de41383d213f157836abedb6b9bf52"
    sha256 cellar: :any_skip_relocation, sonoma:        "240ceea346e455b7663184c1583dedcee605377afabf6579ab140951e6a882ea"
    sha256 cellar: :any_skip_relocation, ventura:       "685c60a24383537411a8b74c0e353b7826f7577af5aa565620533056a1579c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4db683a37dae7e62cab2c4e0b200f24359346616a54f33581f23d67e5037b859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5107aa70755ed38db9a1fd25798591cdb470b6678765fcfe8d79695d3d928ea5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "cratescli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}sqruff rules")

    (testpath"test.sql").write <<~EOS
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    EOS

    output = shell_output("#{bin}sqruff lint --format human #{testpath}test.sql 2>&1")
    assert_match "All Finished", output
  end
end