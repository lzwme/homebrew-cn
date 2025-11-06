class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "c9a58491d22db18c0bbd893da2e2ef5f3b2d6bed3c13c15d89342e5632e2cc69"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9df3b3c21f557dbfa1e2f51af82abbbd6f6838eeb9aa0706e7796f070f0b89f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a6c82adf62a39ef47bcde2cc462e523f4b3b9c83d85102832b720b984a4d446"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f549ce93e08023fbbd7a83d373f0fbc0232d95bc1bde3d906c469f016e15ab95"
    sha256 cellar: :any_skip_relocation, sonoma:        "92aacb76eacc41a406e6e38cf813d23a7ceafde1792cf7d62715055562488b4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d255af5ed396c9e5b78e20bbc6225a44e2e44dd1f8c99283bc3c47927d7418eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1f93502e2f8d1cc8ec0901caac908f582b6d08175743d663b0eb03a6e53e92"
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

    assert_match version.to_s, shell_output("#{bin}/melange version 2>&1")
  end
end