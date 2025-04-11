class TwitchCli < Formula
  desc "CLI to make developing on Twitch easier"
  homepage "https:github.comtwitchdevtwitch-cli"
  url "https:github.comtwitchdevtwitch-cliarchiverefstagsv1.1.24.tar.gz"
  sha256 "8f796e1413b5b9f6d159cbdf5296acb22851822c024f6545acd707a71219a239"
  license "Apache-2.0"
  head "https:github.comtwitchdevtwitch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d08d98edf898eacd95567609abcd814724f4c56a57aa8aee44bc60f2077e093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f4bc2b2cf6a0bb22da7201d2a10f751455c2ea3e937e14c2ae1af2acd8998dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "973a852f7cc2ffbd61f986f9c0de9d4a430c01f01e0559b1ce2398edaa4d263e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4725aaf25d0083d7d5ba985b01c7e7cf1c1aae7d119e69fd0751a0ecf6b1f7d4"
    sha256 cellar: :any_skip_relocation, ventura:       "8c1e78bb23279dd06c0ff8aed3c533d6b3137a7b581fd19f7d0515072d203eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0745537d715247a9d55b4a10a3f7d79942f417a1b7bf3372190b805ddf3b1f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}", output: bin"twitch")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}twitch version")
    output = shell_output("#{bin}twitch mock-api generate 2>&1")
    assert_match "Name: Mock API Client", output
  end
end