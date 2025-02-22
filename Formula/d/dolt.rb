class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.49.3.tar.gz"
  sha256 "926e5dffee22b2e5cb94e322c579fde4134a3ff9f07245c8c00337f945b9b18e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20cf5dc48a3ead042d1d2b950baf1062f07d0c18923f2423a02d853842a47430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1311c2568ec42c811e367af43cf69e27f1a15de4667f68d327c1e3494d659d70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9aefa81d4ed8eb28c4c9d7572e3babad1a753d57fcc353f4d0151dc9e1e6a20d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4a810498d034a6036ab587b8ca6d29cb091201b2988db93e1d35330c7756678"
    sha256 cellar: :any_skip_relocation, ventura:       "901c9e8c9903b825654a75611a2dda85fa2675b1840340d17d9548750e4a0616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "026b399814cfb7c92ed270412afa6b4668738536dd3c8de6bfa4ece7b4a9dedf"
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