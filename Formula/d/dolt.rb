class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.2.tar.gz"
  sha256 "6fe33bf33d050a2821c87ef74579f621d912cf70db287f72a2efc87c09ea9091"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0750008527a43710042d786f14edeec5900776fd58a9a88f2b244b02d33ab2dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15e1c6dc9a21562cef72f1fd225c26795b534aa6be1b4db89d628cdac598244d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23973e495f3c133ee4927e1569f56978c6c8bead802946cca30bd0d6a18850ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b1c5001f1757196dc2f2508f58b3356922f4f0a5eca6722fc5ab339db340451"
    sha256 cellar: :any_skip_relocation, ventura:        "ee15b10742b5a1bc3b472fc73fc7e4f8fd17920d50b4cc8f94809314aaf94357"
    sha256 cellar: :any_skip_relocation, monterey:       "9afb93e4bb412dac7fc2bc5cdd0bfc6615c9b1c648c0258a2c8340d387f574e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c343db1f584c779a1b471a3573340e4f59d27ddfce9c68e857d28a296b6ba461"
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