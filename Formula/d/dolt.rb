class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.46.0.tar.gz"
  sha256 "e54714b1d3790b51bb066fcef6f6c0a63ad29964714548a7f6f6d9888932fb55"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8823db2255cb293f2a623c0b43992724109fa13c365d155ab645349150c2e50d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "090a80d398b391897043dc89f86b247a2c87a381851aa16a339ee77df66b1893"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c97bb9d3e2993f34a8d2819995e4457f5e997a0d776d08fd06a8bdb0a2bd151a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac2afd1c71a9430714b40a0148649c56ab50cb35ae2a5a53d838cccf9d318ab6"
    sha256 cellar: :any_skip_relocation, ventura:       "70c52ccd7e79852a8075b4be477d73eb633ff62cc4e5ea85f9152181e7fd483e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ec91d67078ebcd7dd364d2f90716a384fc39ef7c41d337fff85639b143539f8"
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