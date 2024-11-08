class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https:gnmic.openconfig.net"
  url "https:github.comopenconfiggnmicarchiverefstagsv0.39.0.tar.gz"
  sha256 "310932d7776b2b98a5360b9742eccc0eb7b5b9eb53427e341ffea30d3a839d98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e2faf60ab12e129108c36651ad6cd5a9110ca7047c59851d64d84acfb4f6adc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e2faf60ab12e129108c36651ad6cd5a9110ca7047c59851d64d84acfb4f6adc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e2faf60ab12e129108c36651ad6cd5a9110ca7047c59851d64d84acfb4f6adc"
    sha256 cellar: :any_skip_relocation, sonoma:        "579dffcb40a7defda25eaebc3007a7c100732a1cc1d109bc0fbac41787d211b0"
    sha256 cellar: :any_skip_relocation, ventura:       "579dffcb40a7defda25eaebc3007a7c100732a1cc1d109bc0fbac41787d211b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf9553a383a89b194ced4773df8c2d4753bf5e87b5aa76601d88be8a931b599"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopenconfiggnmicpkgapp.version=#{version}
      -X github.comopenconfiggnmicpkgapp.commit=#{tap.user}
      -X github.comopenconfiggnmicpkgapp.date=#{time.iso8601}
      -X github.comopenconfiggnmicpkgapp.gitURL=https:github.comopenconfiggnmic
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"gnmic", "completion")
  end

  test do
    connection_output = shell_output(bin"gnmic -u gnmi -p dummy --skip-verify --timeout 1s -a 127.0.0.1:0 " \
                                         "capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed", connection_output

    assert_match version.to_s, shell_output("#{bin}gnmic version")
  end
end