class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv3.7.0.tar.gz"
  sha256 "ed1720da0e8cc8532870da8e0882a9ad95cc309b026627a6fc1c3cdaa57a0af7"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b956e9382bd9fb615916d8435d75041ac66685daab8e3c4644634fcd57eead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09b956e9382bd9fb615916d8435d75041ac66685daab8e3c4644634fcd57eead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09b956e9382bd9fb615916d8435d75041ac66685daab8e3c4644634fcd57eead"
    sha256 cellar: :any_skip_relocation, sonoma:        "6afdd64e281b008092ad750a28a04f0c87493fd90e3a5566a937345c2f71b7e9"
    sha256 cellar: :any_skip_relocation, ventura:       "6afdd64e281b008092ad750a28a04f0c87493fd90e3a5566a937345c2f71b7e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2a4bfd1fd19e7b874b7d2ba3393036c1282e33ffcf8f46ecbab2965ce0a3aa0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.orgwoodpeckerv#{version.major}version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"
  end

  test do
    output = shell_output("#{bin}woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}woodpecker-cli --version")
  end
end