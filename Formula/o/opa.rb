class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https:www.openpolicyagent.org"
  url "https:github.comopen-policy-agentopaarchiverefstagsv0.70.0.tar.gz"
  sha256 "c28ce33bbf1ccc4f70625f467bfcb70d91fa4431d82c96e6be39642659007e31"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentopa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06a9c205764380f858dec35ab880eed0fbba9449fee628b93a637ce5196e437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f9e9a5fcb0e08dbedcbdfda95fb5c7dad02a088fe9f10504f11c107feb906d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4393483a5aacb7b5f2125cb3ebef1d1c0bede51f28a35ee8580f690ba0a53b98"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea9d58ed26f0f7607001b4b724bae97429cf403af2879165c9a18eca42855ad2"
    sha256 cellar: :any_skip_relocation, ventura:       "260d5c8945c9e7048c9f968ac7cc2e41e2a1000e6343fa2aed6138faf4046747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6266e73113ccdcfe0a3b0afaa186281379fa5222894d35eab10b0b2766f4ebd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopen-policy-agentopaversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system ".buildgen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin"opa", "completion")
  end

  test do
    output = shell_output("#{bin}opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}opa version 2>&1")
  end
end