class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.29.6.tar.gz"
  sha256 "8b2a02420eaad34e16eb3fd62846c0626db1f14c033127b305196ab837864f2c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "561ab30e9151fecd652fc4721c71e82ef355470c678364708d57e7184c3ab18e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bf9c6044c95739ddb4eb71b41b07ebcaab25849c525cee52d0a4372da9248b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb4b25f3cbbd534b2a00ea6d7bb5f109dcacc81cdae560c9cb67aafd8d3d1176"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa83bd85c1a92a101fed4b1baedc8938e65dc60bd8338363e95adb44ee49a79c"
    sha256 cellar: :any_skip_relocation, ventura:        "9f460d96dbe0108ef597505b504aed7f21d809dc7843d151fc5becdfb77a9193"
    sha256 cellar: :any_skip_relocation, monterey:       "8f9f0211b088953ba33ae234590591a886e4c83a3a52cbbe87ba12ee58936682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b6cbb69cb50da8ad3c1dec0ea2415ce132961679ce2bd62197f6447a2d7df32"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, ".cmddolt"
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