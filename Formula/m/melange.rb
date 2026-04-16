class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "4ec1ed3419ef7aff406da4c4aeb7d3524beec38f12cddae1f90d485ce48ee150"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27fb7c15ed3eb3d1c1901807383ee023fa238ca62720a8bf65654ed410f4d4ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03b368bf35953fe9b7c1a82c5ab0a7c8d6e775f280a1621dbb28b3857b8e1429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b09fcb8264c927e92b1512fd0caef2a6f35b5e6f852a2dca08bed345c9b1a8e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "514daada5d3e37151e2b358056a9535297479994f6b90f077e6e28ff179964b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "836721292f73c9dcded6dd50588f6a2137d4a22b97890f934a3e0f9bfc224330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "667ea90f908ce185e08451647114d4bf71728b41534026baf754b89039e3b727"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_path_exists testpath/"melange.rsa"

    assert_match version.to_s, shell_output("#{bin}/melange version 2>&1")
  end
end