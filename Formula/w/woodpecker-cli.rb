class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv2.1.1.tar.gz"
  sha256 "5b042b610f4dfa4f1ddd888483dbf743d468ac572474d51d95c4bd7dc28df016"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "311938c2127801e8ecf46974e00b24f2b7b0465c45c0f685493daab1cdb62d6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "087cf53c42f594b924d4d7731007bbd1ade22d7ff702428be881599f856c91aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9644a65d84b788934f6611f90954955911ceaccda96090e7a67b66ec0ebbd31"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5795d82b0c342a96a1ecdf8f060f579bccb035ca342ca9fa834fa93ea1051b7"
    sha256 cellar: :any_skip_relocation, ventura:        "a4f13a288062a3315ce1c33c8f6a019ad24b25e01f00384f1a05507df5b869cf"
    sha256 cellar: :any_skip_relocation, monterey:       "1ddfb0dd1d652b11ceab05c9a9036422461fd82abf7599d00448368f1b8608dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8ae00a25af83368aaf0c6ffb3bd05d7fe3460aa97a4e4be9ce6f7e6635775d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.orgwoodpeckerv#{version.major}version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcli"
  end

  test do
    output = shell_output("#{bin}woodpecker-cli info 2>&1", 1)
    assert_match "Error: you must provide the Woodpecker server address", output

    output = shell_output("#{bin}woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}woodpecker-cli --version")
  end
end