class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "7ded5b55af92a2173d91d1180ef02f58c9a9ed68fb15b8b24466c137b45eef74"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "055d0edb61ddd24968161a39f1ef916daac93d3ba24ddf210574b330f9169ef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6e849eaa7a4d74435a645e604707e0a5dad494ba41e48871843555eeafd775d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28c2d377367061f329d8938d057af527e530180bd57bfb81146c3e1f803bfaaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "edcaafdfacefff625658645b043044834969e81cc12a0aaa3fa84e661e88469f"
    sha256 cellar: :any_skip_relocation, ventura:        "2b374894898707ae422c050c1f365aaa4fd868802de1df1ba5c7b08b3b9bd828"
    sha256 cellar: :any_skip_relocation, monterey:       "d110ee6c1c1447d5b421f6f1e318e5a0b418dfd3a38c0aabd96739002b6cb90d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38d1cc1a074198c387078fc4afd920ba61daa9c02edaff4bead523721019316c"
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