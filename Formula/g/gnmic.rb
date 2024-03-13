class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https:gnmic.openconfig.net"
  url "https:github.comopenconfiggnmic.git",
      tag:      "v0.36.2",
      revision: "a7844a6d7d47c302df1fabb845dd22e4e4b70e22"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopenconfiggnmicpkgapp.version=#{version}
      -X github.comopenconfiggnmicpkgapp.commit=#{Utils.git_head}
      -X github.comopenconfiggnmicpkgapp.date=#{time.iso8601}
      -X github.comopenconfiggnmicpkgapp.gitURL=https:github.comopenconfiggnmic
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    connection_output = shell_output(bin"gnmic -u gnmi -p dummy --skip-verify --timeout 1s -a 127.0.0.1:0 " \
                                         "capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed: failed to create a gRPC client for " \
                 "target \"127.0.0.1:0\" : 127.0.0.1:0: context deadline exceeded", connection_output
  end
end