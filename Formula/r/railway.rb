class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.11.2.tar.gz"
  sha256 "138efb5e9c5b663c0dd0eda0c30eff73efef636326390f92a3bbea0d27b7fbf1"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "447183ce9a955058e984fa37061f6ff490cfa9053f6cede0dd20a785ddeefc65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71aca73e22faf82bf3d99b2dfdfcccb455da637a89fd6325cec4d592deeab261"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81cb2a138fea8c05412050208b4ab7bdbaaa30da93c7b288c3d56b55080c17ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "94855706ce46c5405def88cf9d12151f976f5b5d2dafe7891e5bfb8cf9b8b746"
    sha256 cellar: :any_skip_relocation, ventura:        "7ac67cdd541440e7a0a39212fcd7ad1c9444255729ddb7bdde6cc3cceea3c089"
    sha256 cellar: :any_skip_relocation, monterey:       "d4b7a6a7eb5d291176978252e095094b4b2bf72303324729b8c5c24e625627eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d145abb019260bbb278b79aeaad951dda645da52e3859acd5830811cf4526d50"
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