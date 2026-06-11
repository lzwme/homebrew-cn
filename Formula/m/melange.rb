class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "40c2a542cfb34459c50f480cdc6301f2b96472ec535fec98462fe2b7a93ffd09"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46986348aee7addd264871b80c826ce4efc419aa8c490d4873af9316eb542e6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67e0109752d0dcfab97adff79db151e80b7ecbcd8a5863092f1767ee5fb834c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcb42a844e5db09e457c88a22bb63b8d8bc0691c3c034748e56b74de54009f9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a20239e27e1f9f4d8f1bfa0c6c9b9e6878ca7f3eada783a03ff37aba0a1a6857"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cba251a50bd8ef97b767c9f8bb0f3d5ce289f778e9e258c87b7ce1d1176857a"
    sha256 cellar: :any,                 x86_64_linux:  "9ed2484721a28f7c6b9aa60f1f6e4b80332ba9bb68056809709cc5da06abd9bb"
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