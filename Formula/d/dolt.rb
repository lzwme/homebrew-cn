class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.44.3.tar.gz"
  sha256 "0a118260abba450372b336aefc6e8e85e44d848478c2b5b755d2d5786c30f4d6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbb00e46cb90470e370b59a23365ace7a4508d862e190cff534293d28737f3be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a78af4a3de7e4ee2be96d989f30b15aefd56c4a667e29ca1428b84cba2569758"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "211f81de7118b4f3210f14ac93ded85dedbece11fa19421ad04e59aec4bd62ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c126d603e6a60176ddc442eee7f3aa8debc9f71c1dddba8c61ddbeda5299d42"
    sha256 cellar: :any_skip_relocation, ventura:       "0590e3583a6c311573ed17738014f4156b7111dd55a4dceeccb65da794b93115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd603ac732e6804410cd82cbba2022625560917e6927aaa3256061ef37995707"
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