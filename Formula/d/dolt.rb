class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "69572744f1c42e8dde7b91424c79aaaa5e0334fd3761dcf9d6fb7861bad79473"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8db82ac9d304b9eb007c5b2f41492a5f65af0c512b5f5abf3413c517187187bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e02043584985a5ef4e34e85b7df830785f24f3d3def1f5ce9c7990e1829b8754"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f347935b2c8b5fe80e9df19533c90dfba4a40486d9a1bcb16073f175113f29f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "31b8bb756db1529ca8a8dfc85630e5eaa2424d111c3d522d99d9e229b6524900"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a631829a380eb378177bd3962296ca4de6a3be380c3545e4754253bdf14871"
    sha256 cellar: :any_skip_relocation, monterey:       "4ddf4bdc887057c20da674143ee30fe4a2f4a874826199d066f12be22306a451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7f8d98f22566a03b708f9c41c7794948f8a48ccdf1a591fae936e580b9723a"
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