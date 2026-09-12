class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://ghfast.top/https://github.com/openconfig/gnmic/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "444aad2dd219a39c0dba35f8537572b1c5fdc5e847f25ba00d2f0379293a3921"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb1ae434c2261ba6166e70e10044cb928e68a261171652e338b1ac5be0384907"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b5b56ea7a0f47be09285a7195924c23bd51a6408dfc0c9f65e518ab8edd3028"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "571eca45d57175c2e37647170cc48544de09469ea3e824e075549afaaa61c241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "9c35c8568ff68cafa63a08ecae0ec9f7a8ca1e7cebd605a4bc09aef5a7b69c66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9b149b1dedbe6ebe36489a3c9f88525fee11e04048349809bbb866b5e1607ea5"
    sha256 cellar: :any,                 x86_64_linux:      "f8f1c060bc7e6e140d14603d6d7ace2e66308b253db10bdd3cd0156379d15009"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/openconfig/gnmic/pkg/version.Version=#{version}
      -X github.com/openconfig/gnmic/pkg/version.Commit=#{tap.user}
      -X github.com/openconfig/gnmic/pkg/version.Date=#{time.iso8601}
      -X github.com/openconfig/gnmic/pkg/version.GitURL=https://github.com/openconfig/gnmic
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gnmic", "completion")
  end

  test do
    connection_output = shell_output("#{bin}/gnmic -u gnmi -p dummy --skip-verify \
                                     --timeout 1s -a 127.0.0.1:0 capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed", connection_output

    assert_match version.to_s, shell_output("#{bin}/gnmic version")
  end
end