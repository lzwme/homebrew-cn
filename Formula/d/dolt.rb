class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.30.5.tar.gz"
  sha256 "d31f6291b4e5a4052ff25ac3269bea1c42f5feab5114a20df3734dcbf2036525"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bef286ebf48f4789527c9e1227660af2495ed572c8bc02e896499ae5ad8b1063"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e746e594ec54a4f640b3a81550e06d261cdaf3168b4cbf0c9ae10caac70465da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46a707025dbb530687b70d4c49a4199efada4f5949782ac289f1fdef66c26df8"
    sha256 cellar: :any_skip_relocation, sonoma:         "53f2ce0a7c60fd3157e8a47711b5883110302b67f1aff4117847158c33c7b335"
    sha256 cellar: :any_skip_relocation, ventura:        "816ef91045a6a5fd2ea083b725d95b2348bf35ee9c99b26864a706f726972940"
    sha256 cellar: :any_skip_relocation, monterey:       "9437827a875ce1da70b562fd2917999880da691e464c11495d8365c8943dd157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71eca89033822aec73598ecf15e4c79daa72a2df4556d2161cb19f103061f3fa"
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