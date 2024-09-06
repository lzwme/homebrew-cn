class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.18.tar.gz"
  sha256 "05d5be4121ab95f62347564b22c7cc2bf13b21891417696178e5daf37f55320b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "977d0e4d8bd3fd93f442c3fde9eeed271d1635bfa874b69b75297ec308a3cae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf66fedcbb5cb239a5e0b12385e25819f69ed036a3727030cf02e7e6e70219ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2812a8fc7719d4c994b55b1bd84d9abf3ffe239fd77f8b1968953c8fca71df7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "438a5fae2fa84e06a014354f26cab1f659b25092ef88aff2a6cb50bc4e87202d"
    sha256 cellar: :any_skip_relocation, ventura:        "4a602e16ba8d2dbae9cad49386a2a332406edbf533f20c1e636c41e6c2ec05ba"
    sha256 cellar: :any_skip_relocation, monterey:       "15c6864318b0f34ea7291c1880b1b95f4660d8d441f43bc347e63727c6fbec42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3c75a8fbdddd0e587f1e35643a592834865b2ba88b118f03ef15377419de47"
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