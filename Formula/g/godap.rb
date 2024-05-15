class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https:github.comMacmodgodap"
  url "https:github.comMacmodgodaparchiverefstagsv2.5.0.tar.gz"
  sha256 "37eaa386166950625218494e95db03a1fadc6e81777ac279d15374bfc9763d6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "707c43cd1ff852cd1adfd43d5ed643019364f8e7f027a33c484bc0fdc96364ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d64112d8324a6ea24470a5eb32925964362d633ecea8ed9d9af23e8e7d48249"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0c468757dd4193e2c4a2f4d88debd2248fe8335798f3c7d07940ee295153362"
    sha256 cellar: :any_skip_relocation, sonoma:         "85aabe8dad624cf337243532bfe268ef8ceb664752afffff587801bd970bdb77"
    sha256 cellar: :any_skip_relocation, ventura:        "e429d29642229215b68b05442f4c43b3e4add4c16fba7cfbafc9ee264bd3257e"
    sha256 cellar: :any_skip_relocation, monterey:       "1777784c3c2152deb565284424ef47ba7d1a5df8f19db548ecd3e293ef6a9a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cbc813a6c5ffcb592fc570f73185c781b2ad705d6c3468973bfc92403a5c4c5"
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