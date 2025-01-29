class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.48.0.tar.gz"
  sha256 "731b9d29ab425151fbed002d44a3c31045275f7243fce7f24394197401514f6a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8c8caec07b4f2ef182fb4bdf1ba778bcaad6cbab6de2410e9326a0fd9c72ef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b572a1bd85758fcd06637678ea727c9f42166e1788c0c4584d96fac9eb455747"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23d384d68d9aee7bb0ea0b6b8682ba00bb9b456d9a3786ff6c373379f645788c"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e7d00c0661f2ce7b045d03715eb5dcd2419bc0dc999b12293172411252da68"
    sha256 cellar: :any_skip_relocation, ventura:       "c09ac1b5b6b34454bf4db7102aa0d6cda399e2a694fdfe7b6d1fad0a8a9902e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97457c862d73e3d75ff4316064772dad8dd835d8ed82345471ea786553363469"
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