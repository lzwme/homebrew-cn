class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.45.3.tar.gz"
  sha256 "11e31953de3a7f63733c62c94ed00db584d43081fd6c4b3b74ed16dc8f7f2021"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5682e125c50753dba447a64978f4be0a89d065d822462a2b8517e1f0c27459ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "821cb60ecdffde19b72299f47b07f92fafebda61001570a2884c04733bb2a9a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d78250e9354845512a241867f435261cc0a195195ac47094f5cc01aa632efca"
    sha256 cellar: :any_skip_relocation, sonoma:        "58fed513f26eb8ab4348019aa05e464f279e550e69477bd587569e8fe66a6bb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5ec27d59e83ee7f3dcc28cf8896dab91c6ac774637f52449470f86281035664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114bfb90d1589d9d042abfff5eb15284cc9d8dcc5e8eb4f8989defbc7eebb988"
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