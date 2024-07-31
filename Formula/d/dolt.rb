class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.6.tar.gz"
  sha256 "dea040ee10b37491933c8b4bb4779e48b41061089c2181cd757cf10d6923ae84"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9c310745bb14f5f745350b4ea29a0d801441d26b730c8fb1559137bd373c5cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c17ce8192cdc16a8c2e9e6b016de87c23b4257380fa8892166042368a5266aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c2b5b4976171a5f47b4033e695ef983d6b073bf2b07a1ccedd7137a93f2a2cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0523690bcdf562366a207149e006853f999ad838eca644a693c67d7cf53195b"
    sha256 cellar: :any_skip_relocation, ventura:        "546f1158cfe8c5f77b3d553841a4edfd44a04d12d2cd8998eec0f2292b582fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "25560d8f44fb48a6d8b21c528532bd64f8823b319b4b0a9bda1b7450756ee0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5db4c5bf3f43964690150daf973bf6bf0388376db8fcf7112c921a5c407aff"
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