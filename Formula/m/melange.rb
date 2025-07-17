class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.29.5.tar.gz"
  sha256 "5bbc0d5e017e9f7fc0ac82c6eb315b47d63ee837d6b78b9ac09f4154b50690b3"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c77f3a750bfdf1bf6dc0b7d801d3e98e27dfde6dacb38eaa1553f6e70008e23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6af34a81f33b9fbafa75ab5db870f639db115a040b8003831d5aa9fb6393f00a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3554a74f373d04beb3eb200bbbac6f8fe6e7016c0489384404afe262fb3e5b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b84796f686499d0dd035ceb6428bd3cef91a65301d0316664ce620b3363d7837"
    sha256 cellar: :any_skip_relocation, ventura:       "7509a54be679855b7e7a72a43859086f07919a911be2287a7fd5d9ecc0c5c165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92deb9706d51fcb39be550c2e4f86506a0206972f4ab87de0bdf8e89c498427"
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
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", "completion")
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

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end