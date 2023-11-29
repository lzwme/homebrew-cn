class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "aea0b9d68d69722360dee1945039bf60c92d8950d73694ebff2b43ca53283347"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "673b5b34767916077862c565103b4f15e316069f31c8ca84b5eedd7be0cc5a35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f3201350b044e48f2dcf751bddcf83608949d6bcb5e2542706db60950946d15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e87401f7e778834008d73fe14ff0f917107092ab50ba2adb6bd2ef99081c0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7784c005cda13ea869f10a7233a0f88a20c17f00727db4b48d3db8c288bd7512"
    sha256 cellar: :any_skip_relocation, ventura:        "f44bb2d708d9f21bc621136ebb6c77b5acc7c49729c81ffa4a1c90255e8156ab"
    sha256 cellar: :any_skip_relocation, monterey:       "878475517499154dd8467b7354575f25a1df33a632ab00d9fa9198e2831d9f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4fe1db1dd5708ee34cfe21971fb6779a28e9cb143e1efcb8a84cd37c3fa4a7a"
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