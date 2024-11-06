class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https:github.comMacmodgodap"
  url "https:github.comMacmodgodaparchiverefstagsv2.8.0.tar.gz"
  sha256 "1c70dc57cba0629f9600534b63134ebeab42a3f43f1d2d166605bfb25c0545d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51ebba73a8a5919595a39ae1c2ebb00c71ee1533297e54650bd989395012e51e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ebba73a8a5919595a39ae1c2ebb00c71ee1533297e54650bd989395012e51e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51ebba73a8a5919595a39ae1c2ebb00c71ee1533297e54650bd989395012e51e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b2a3e41a5e1606e45c62103bb800cf9e02fb0009d61093872fce526120b94c8"
    sha256 cellar: :any_skip_relocation, ventura:       "2b2a3e41a5e1606e45c62103bb800cf9e02fb0009d61093872fce526120b94c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c834f750281b744fcc9ae4f909e85146eaa3c903fbe76e6bc92a963db4ff9c6f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin"godap",  "completion")
  end

  test do
    output = shell_output("#{bin}godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: io timeout", output

    assert_match version.to_s, shell_output("#{bin}godap version")
  end
end