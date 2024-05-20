class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.21.0.tar.gz"
  sha256 "8b6f829d5894a20119f92049bb92653ac67c92db15413aa4e1eae9adf639729c"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18f52b262de34ed2c5b81dd478411efb463dcd102ae99ae6c79ea13e05420178"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5d38e24a7997e0e7febac89ff196ff96a7d02077c9cdcad86c768b320fe46d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71815e9d37c2760dd215dd0c3948580bdbaefb090c14e593b2cebbe4f55cc29e"
    sha256 cellar: :any_skip_relocation, sonoma:         "08abd77e40743f5853fc46040ca735abccb927f6ec2125b97ba25542c2ea1896"
    sha256 cellar: :any_skip_relocation, ventura:        "cc6e1372b78b1442b33cfb3a821639a0a68fa7aaa4c6105a2fae00d170407965"
    sha256 cellar: :any_skip_relocation, monterey:       "be1f7db9b27f4ed970ecfe9559dab7dff1583d516314518b75dca3bed1cec2cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c679c070ab517a1a79d234e27cec3ac7be3e346f5e438b4fd5c0721d7e012eb4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http:localhost:#{port}")
    Process.kill(9, pid)
  end
end