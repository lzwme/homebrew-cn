class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://ghfast.top/https://github.com/openconfig/gnmic/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "eae6d07b1aeaf1e21a9342522cdee59a27ae2d020e8f84ecd03e0be10098f521"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24d1f312845a0f43f53d746b30592164b74af0039d139256605606418336798b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00ebfc5a9cb6239dee42af766f04ebb461302ab11f38b2e61a15d950e4f88fc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d39ac73d0f01d7466932be8db60101c2aaaa79be155c4e979437af70dd3d464"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f6ca25d0d2b9d1baafa759941252c28fbff40d5e4f299620ad964a2efe10b67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3ca3fdc62667581cfbeaec012657150d6136bece46eb966e325e92014a9a654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9eac38a4e852507239fe4106445f52da31ba2758c5236fb29413607d1da4184"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openconfig/gnmic/pkg/app.version=#{version}
      -X github.com/openconfig/gnmic/pkg/app.commit=#{tap.user}
      -X github.com/openconfig/gnmic/pkg/app.date=#{time.iso8601}
      -X github.com/openconfig/gnmic/pkg/app.gitURL=https://github.com/openconfig/gnmic
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