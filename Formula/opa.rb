class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghproxy.com/https://github.com/open-policy-agent/opa/archive/v0.50.2.tar.gz"
  sha256 "6b95534d83c05910b656d29374b7a588cf292d60e3adc2238452426e241d5179"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1205fdfc093071233274fe1545ae4d85fbd2303ceb8f0e3e136012170dd1b28d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a922f1435b3cd63fd4a46900ae1346673f925b66354aaee5403e2bc62b6d81b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3a5359a31551cb92292f54827eaa8c8be1d26e8c6ad3b5d30f746b627b4a6b4"
    sha256 cellar: :any_skip_relocation, ventura:        "339109669a26f209d11c1aa18f66a4b48901e22ea207c0d22de300e9679c2566"
    sha256 cellar: :any_skip_relocation, monterey:       "e9e28a0782cdbd3b732fba3e718c59c32c7a4e31aa8b5c43366442651006482d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d495024f14ae9898b0235fe6f76248dff67ea3a0b58aaa34a41a641143f635b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415b340b20e60667a3ca48ca817caabd5e2afc13a0e75ab6e10557fa30cf7797"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end