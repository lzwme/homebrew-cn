class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "4f1358d8fdeb92b7f0f2f5e80fd58f4670e695ec43034551e835a6596c2db9a2"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f4698a184dd5b74fb75836626b50990cf209c15303c2a3737c7460c3055efd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17c88389f834a399515d7898a5f0b100c659834553c0d6156cc2d87b95749296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f22f279474f4582b0bf428dc37f750f893bf3f64f35035b07d20f307439f886"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1146693a04bfa3e6f15a474cf95e228e3dd7405a12cc02eb7195b318ea496f2"
    sha256 cellar: :any_skip_relocation, ventura:        "31e45bafa32a894a45acd69e8830d9dc6466ab3a4bfe725c74553a46b8e34319"
    sha256 cellar: :any_skip_relocation, monterey:       "9f8b2edb025b2f4d09a35c70e327c37711b65976c31bae1baab44d9d15dd0013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd10b50b432ed7a7d686f07aa357a4571290a5d5dc82488dd54b709f16d38a08"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end