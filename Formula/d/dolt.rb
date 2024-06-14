class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.40.0.tar.gz"
  sha256 "dc2de0abb89e9f82fa1e03bb91a94ea53e5f3da8a4606b741b007a7a5e0dc5b6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99d0241845ea709483c3f09df0d28ffb040bf918313c122481f6a73d6c686c0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29f93685ea882245720efa877f14998309c743389fa6a485fc87bb58890c1047"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e67f0a20a8e944884c274376b16e2a7d7b49df7c2fc94b27b1b0a08e698de1a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecc9f2c0fe6f42054ba6fde6cfd85ca9a0aea2c8ec881394006d3e7c29369936"
    sha256 cellar: :any_skip_relocation, ventura:        "d8658ca6c4687a28b531cf72b43dec0c7266c1518642f6ec1758342e141a5c52"
    sha256 cellar: :any_skip_relocation, monterey:       "c623105ab77690750edc254792aaa7687a8b3f05bd79e651705f0213e3a6b222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ac64c9939ec87a267e77fd5756aa9553878f881ec3de66776b1986975be79d"
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