class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "35f15d9e3a41a03008d3e09d354ef2cf51149fb0a2429cbd25329c2822fb2407"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3f0489435ca8d976b1c51b3990d629de862a2cfb3b489b3379419e72c5f9f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21f27858a87209a1d43ae05bd7fecbdd27e5f5c4afaa7af32ded996c7e98e4c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6520519514e199d29feeeffb39edcd955417731580c9061af8dbf16475a1bb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "63fbac63c9efa1ee8789f3ed623c5537d46859b8c951eb8d49152c95c21a8ae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c5f42b6fe27999ea8b7a2145d7b7ff18d876d9e7980f757a24893c6c7c58165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b8a6b22002ca90848d5eeb96a17bdf4d6d4d55fe75dfe2f1a5ac0f6aa54c034"
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