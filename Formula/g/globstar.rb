class Globstar < Formula
  desc "Static analysis toolkit for writing and running code checkers"
  homepage "https:globstar.dev"
  url "https:github.comDeepSourceCorpglobstararchiverefstagsv0.5.1.tar.gz"
  sha256 "3b00cbf096e43d5973c408939fd2dbf71be0696cc58ef0694b017c38cb858145"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45ad2c11adc4c28da3836c15f22f4318c52d2a29e1dc28ac876cda068a88cc4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b560b75268a0781a780c92176e46496630338906259c12225e5e6193d45ef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c49dcaf5577a2e8ec134cecc760c7ee3a0206000c7cbc9292ade1c75b408f5f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "116375d39499ba2150c9ec17c2615193770b6a57fec59f9031f19af84612862a"
    sha256 cellar: :any_skip_relocation, ventura:       "0348cd49b847bbb725cb24380ff0eb75c28a87301253155b4ef0fd81a9c68254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bf25fdea6a172a3dbefff55a657439ea74d99ea08b8cbb307fb5dd36476bc93"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X globstar.devpkgcli.version=#{version}"), ".cmdglobstar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}globstar --version")

    output = shell_output("#{bin}globstar check 2>&1")
    assert_match "Checker directory .globstar does not exist", output
  end
end