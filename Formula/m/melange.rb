class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.31.9.tar.gz"
  sha256 "ca622541d9961e845ff54251898ee1521c2ea9bcdddf1aa51e4f6b2257007ce4"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dc4e037f08dd03ebf0576a15f7a7200e1d7443adcbbe89b4f1eb1063d90eade"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52bd7f2a96c6f360ef3acdc69e427ee79bd9335448011a766a6edab8cc6d8a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c0a3a9b1064099d54908fe0fd16388337907c4dbf810c866a19fd829e677b42"
    sha256 cellar: :any_skip_relocation, sonoma:        "c726df97957a6f2045ea3e51623d244047c187974e4b012f255926eb08a865b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c200c9f3ccd5b0af075abf5ae93cd28f38167e744f43fa63b83cd508f163c693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5176a48e2608304eeb7c785a380f6f1b8782b6775d9eb6edce387075d89a151e"
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

    assert_match version.to_s, shell_output("#{bin}/melange version 2>&1")
  end
end