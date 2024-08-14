class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.11.tar.gz"
  sha256 "0e0562c6598146fcf602162eb537cdb15e0dbc325ac9acf1cc228ebcc850b0d7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdaea2232863ac5f277e4da3a9c8e6f54fbcd6f22da0900983596f2d47b65f16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4deef6fffc94a81e2d42ae8ad91a2231a03d6e1f1ed7d71f8e1dc89a7c69854"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "823f075738b34e8109b70af1ef4e4ead069d058e614a1529d657d4dd8c742f80"
    sha256 cellar: :any_skip_relocation, sonoma:         "80d84be198c23e806f8f45caa147e8654c66028d14e31aabfc90a4889bb6e106"
    sha256 cellar: :any_skip_relocation, ventura:        "4828b27b7d0ce588759c669c7bf5a664a41931433737ef1c7249863c38077697"
    sha256 cellar: :any_skip_relocation, monterey:       "81c2915958b15946fa28296cf048e3a6ae0785fb1da5dc1b9ea87547c4f348a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84ff7359b8803eb4eb01a61a442c88320f5f4ba63ce1a7fcb536df3f88dbbd91"
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