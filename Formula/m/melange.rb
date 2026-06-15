class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.53.2.tar.gz"
  sha256 "09f4fe08aaa5810d31ae51a413500921b7dddb64da22b7a2c5be990cc7147c18"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "326fde4fbe36874f4da4a554e631be65c834531e1edcad3899f6aef1dff7c510"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e25d49fd3ebb7e824b3403d14faf43d33a358e38a306ace28c5f84fd8ccbfeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e4f3257bf8a9cbdcbac77cd521de81a4ef136ba8ee0cb934ca2964db32f3ec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6351dede285107cf1bb604a6376798be9cb15d2203b1e2e6777d41f1283b13db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "149d135455f6905f70b984262156f6e9a1cbb585084c1f07a8811716c2137757"
    sha256 cellar: :any,                 x86_64_linux:  "b8ee6c8d4d7150b9e32985192e0aa761f9511e9d7b947563c3eee17e9b475ff1"
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