class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.56.4.tar.gz"
  sha256 "b38e4ed09c5b54ebfb84bf12e87423ea2654329a78c6fbe91101faf05a95e3b3"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41e49df9cae8aeca1bf5b1673d81532c341b71a9f6a08a31eb8275a2101d88a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c648cac332f9137ac56990ca9236250ce5e62800a9f16e3f9c3e195b14a19bb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ce41d45bef37a352ffd051936ded973c9f8e69c87e3a16f710a77c5d6812fb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e04c0169cabab174ab777ef02d14d435314639542541ef4472b55c4a50934c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "877f311ecb10c59c45b1fe0f659b97d6d936a5b0232780dafefc7e2bd0e1e288"
    sha256 cellar: :any,                 x86_64_linux:  "7b3c99e483767d1cb49270ac0fe13ff6660d96c19766785d95aa488c70bd4ae7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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