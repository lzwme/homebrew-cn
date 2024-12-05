class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https:github.comMacmodgodap"
  url "https:github.comMacmodgodaparchiverefstagsv2.10.1.tar.gz"
  sha256 "3d34769229bd3e21fe6c3230fad1f593461d01ffe38e0aea4f0970095e7e5318"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9ff4270c77241a1cd5177538df5fa7f2a7ce3e23a902e373aee1136fc22a146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9ff4270c77241a1cd5177538df5fa7f2a7ce3e23a902e373aee1136fc22a146"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9ff4270c77241a1cd5177538df5fa7f2a7ce3e23a902e373aee1136fc22a146"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e312c0ac61c56b2fa3bf6ea92f9fd344ce57077e7fc8baee1ef9ecea8bc8d4f"
    sha256 cellar: :any_skip_relocation, ventura:       "2e312c0ac61c56b2fa3bf6ea92f9fd344ce57077e7fc8baee1ef9ecea8bc8d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1863505c134ae0a39cac085826522a2b31c313a3892bbe333f4c395771af02"
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