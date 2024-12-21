class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv2.8.2.tar.gz"
  sha256 "d42d047845032910e34c4b2bc94e61efb4ea41a65941033e4e3261e685d8a3e7"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8aa6c95fc0f8a557ecdf86ba48c2be57aa92dac96dee8b6be5438c191a786d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8aa6c95fc0f8a557ecdf86ba48c2be57aa92dac96dee8b6be5438c191a786d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8aa6c95fc0f8a557ecdf86ba48c2be57aa92dac96dee8b6be5438c191a786d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f95ad09c863a17310505881e784d12c7624d2c89e92716916af165b9a4ea2e4"
    sha256 cellar: :any_skip_relocation, ventura:       "1f95ad09c863a17310505881e784d12c7624d2c89e92716916af165b9a4ea2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbd9b3495fb8513028fc07ae6b6eabf8735c5404f919e2ac70b850f52b9b67b9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.orgwoodpeckerv#{version.major}version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"
  end

  test do
    output = shell_output("#{bin}woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not yet set up", output

    output = shell_output("#{bin}woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}woodpecker-cli --version")
  end
end