class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghproxy.com/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "65f248fecf72ef36303e6c61c5599272f1a0d3eb1fa287a6f021917001e29a0b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be8333b0d4db2e192c9304ac6cd3afab22c4091d899d9971a769f1de95836202"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be8333b0d4db2e192c9304ac6cd3afab22c4091d899d9971a769f1de95836202"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be8333b0d4db2e192c9304ac6cd3afab22c4091d899d9971a769f1de95836202"
    sha256 cellar: :any_skip_relocation, ventura:        "301f5bdf8a26ca2f1dccc5dda852543f4d0a3fa8106dce84037e998e381c093d"
    sha256 cellar: :any_skip_relocation, monterey:       "301f5bdf8a26ca2f1dccc5dda852543f4d0a3fa8106dce84037e998e381c093d"
    sha256 cellar: :any_skip_relocation, big_sur:        "301f5bdf8a26ca2f1dccc5dda852543f4d0a3fa8106dce84037e998e381c093d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7de7fff984ced6de34cdd495822d342b44c2170975ff73507ec1499d0f018dc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~EOS
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin
    EOS
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end