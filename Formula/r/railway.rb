class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.17.4.tar.gz"
  sha256 "fd2de790d0b2a52cc7b2ae823a309a58d16982646d2310e5f885f7776a904933"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a971902bccc3e11bd69cfa2b7cf5b95e9aee0416e61e6470234556bf4fc47f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54c19d791489d35be0f3b6ee2dc358074924c7feb3a9f376ff55dfb3131e6531"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80cb15a22538a9a315be47076d148e0124bc4a77cfd8ea7aecbf582577a4b346"
    sha256 cellar: :any_skip_relocation, sonoma:        "588f0b6c60b475b27d6c728a81f9a3820b5982f2be923772da5131d990d1d0b2"
    sha256 cellar: :any_skip_relocation, ventura:       "03a0b89ce1dbcc6f52856c0b0e17ffcc98eb4c98446d01bc341ffd97727cc889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a86c5c3a473b066eec2d6ac86e2c401d39fb9023bd1933d7902a39d588c4631"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end