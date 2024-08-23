class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.60.tar.gz"
  sha256 "04578be02b0d87f89748e0828d02b9ccf2beb5c3d88f6a9a6941f710cb1ba333"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa474f327c667f8fe2e352dd3285735f75150cda644de627e45372b83fd692d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa474f327c667f8fe2e352dd3285735f75150cda644de627e45372b83fd692d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa474f327c667f8fe2e352dd3285735f75150cda644de627e45372b83fd692d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a76ec110bf31987f03720ff08b7f285d7efda1ca61264a8efc06f3a56f43cca6"
    sha256 cellar: :any_skip_relocation, ventura:        "a662a5e05b3a3c65d6966f9dfc932beb3631e8923500ad05ac83af86460da394"
    sha256 cellar: :any_skip_relocation, monterey:       "c5b1b09abdcdb50debd3cdd13fbfca5e880cf46799cdb0aa11875bcb6980511d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec14eaf18461925168a9d2e18dd56efadf8a87a521c51ee1e237600d784b0a4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end