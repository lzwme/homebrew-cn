class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocs"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.13.3.tar.gz"
  sha256 "9a77740bfa53d21ae021093700f228907b7f35e7dc43851e0eb360bce56ed3e7"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "458e9fd5b0037fa6f3c2e725453d00125a39c4c31616f0e162c2c7d51ca10c2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "458e9fd5b0037fa6f3c2e725453d00125a39c4c31616f0e162c2c7d51ca10c2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "458e9fd5b0037fa6f3c2e725453d00125a39c4c31616f0e162c2c7d51ca10c2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8048bc523078dc2b73fa822c2fb5a5844d1ef5d439a3227e1a2cee488e33605"
    sha256 cellar: :any_skip_relocation, ventura:       "e8048bc523078dc2b73fa822c2fb5a5844d1ef5d439a3227e1a2cee488e33605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c72d252e0b7a7f6dc1ef72aa20754f4c8f83edbf9c4418d09f2f4a101c975413"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end