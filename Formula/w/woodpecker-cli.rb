class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv2.8.1.tar.gz"
  sha256 "03a263566c307eb7d5eedb212479e88acdae5c21f7e38376a8795cdd44ba4f43"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "035b9922083c23708875365f1141d8f87ca79d55601ce2c83e4d6f9a5f6bcb5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "035b9922083c23708875365f1141d8f87ca79d55601ce2c83e4d6f9a5f6bcb5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "035b9922083c23708875365f1141d8f87ca79d55601ce2c83e4d6f9a5f6bcb5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c78b1a4907a5e015a940db97615c3b9d92107e60ad4a9a01be552935a60466e"
    sha256 cellar: :any_skip_relocation, ventura:       "0c78b1a4907a5e015a940db97615c3b9d92107e60ad4a9a01be552935a60466e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffbde2a4faff32fa91970d9f376e05c851644a55e5e780f326cef1c5006a9f2a"
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