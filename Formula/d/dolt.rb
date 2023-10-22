class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "3508a28a05d51e6937bbd69f4544b80f1d3c6b83456f2ecc19e0333afcfe7298"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0eecd724ed2a15b8ba101c8d9d376fe15a33d107754a5475a570ff09f228f1f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "110486a40b435105070a2ba700f42f322d63c28a28fd06d86493fab3ffc65ee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "685e6ceecd6a0b3654ea6b0353bd7301659ea4dad364bdae1b70fce9bac74cee"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ffb982beb2cfc97b3b5a86a18e78db60b9e83dbac7a1addf126a040defd5c05"
    sha256 cellar: :any_skip_relocation, ventura:        "907536214e4d34ce1b919f1297f400991efea5ff2c1dd48685024d0e64ccf796"
    sha256 cellar: :any_skip_relocation, monterey:       "44e5edeaa9c95c01bfa7c673ec8351b0e5c78b7ec2063c21379ed305dc95eeb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94300f85f6b0c0191991f55ac6670515991891e23320d8483d0da87072549123"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end