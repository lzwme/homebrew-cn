class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv2.7.3.tar.gz"
  sha256 "741beacca372001cfea78b56252f45c5ac68328fcd288a73cce1680fa1d65182"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e0f65badb6bb0cab5e85dcb8158d0e90991144d4cd7747a1ca486952a1ad074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e0f65badb6bb0cab5e85dcb8158d0e90991144d4cd7747a1ca486952a1ad074"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e0f65badb6bb0cab5e85dcb8158d0e90991144d4cd7747a1ca486952a1ad074"
    sha256 cellar: :any_skip_relocation, sonoma:        "adcca144292cab6588fc7ec84bf5466a50d854eef5693a1d55f9269cf38de943"
    sha256 cellar: :any_skip_relocation, ventura:       "adcca144292cab6588fc7ec84bf5466a50d854eef5693a1d55f9269cf38de943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dde3a061879449f1857c25eaa99c71865c7d0b84a2188a9ad3ab5b67433cdd86"
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