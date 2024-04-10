class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.42.tar.gz"
  sha256 "5539e0ba65d26e1b1959535a60d77acc3b08edbff83d5a89536a756b3979d0b5"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb426867d62b3703c0513f4ed07d329b7a0fec08cd8990a2921fa6b61d4b4fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e256acab85a56ab363e36e8949de5482bff76fbad3725f8840ac4d8d9f6b4ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb25b4893239095c3cb6cf15cabfe85b2edbeb5dc9504e6710ea41c03e9d0f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ba8e4433f8079de128671b65b6c437d65ff3b9bfc91a46d11df5cabb5995230"
    sha256 cellar: :any_skip_relocation, ventura:        "c112ad8546cb42df896bc60c7e8cc02f9fca4ce9228351e87f585235a04015ea"
    sha256 cellar: :any_skip_relocation, monterey:       "6448326cacd1c151302b9e63e5870a01445d0796f4760ad2a7ab1b3b695d9047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5668eee4885d5842cf555c2ff4fe20879c3480fcc6f3f5f816244e23b6130801"
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