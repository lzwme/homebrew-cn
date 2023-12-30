class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.30.3.tar.gz"
  sha256 "63c6e6f3d6fcb21977b16bf46d302c32d9edac31f4e9fb5cc8f83320297e289f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed815bb3b4e8ab1d9de690bf8defab6977598e68e4b0b0210e4a40c82ec03342"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90ca357be5e6e29c0d356739fe21c8aa2225b379cdeed8c6a0370aeb0a58c1d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa6beaa32813bd4a9c60c30a97018bc63bdfcc0e6659326a14fb3d3a3f3248d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "031c26626c1381763e5787958d2a567d96bc6d5f5bc7d365023486af1208450a"
    sha256 cellar: :any_skip_relocation, ventura:        "fdd9d2f68e57aa6b4be828c3fb00d4771cfa78279b1f9ffa03be4eccedee5e64"
    sha256 cellar: :any_skip_relocation, monterey:       "0b80f3781ed6626c1823047c8bf466e1027eed6b3a48c699d6aa852be205c606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7918a3a9ab19ee21e66dd4fc69629c599ff383b57cbe127e37afa6c25eb24f90"
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