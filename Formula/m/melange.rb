class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "128966702676d2e29f31034671fdad262b8bef31f3e15a02012f3e7eef7aba1f"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4eaa7476a1616226e411960b8b7e86d4e5a44952b6da4e07a0d27bc6ba8d79a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba2719ae408cdc2cf475dee3c974e30aaa4f1f1798c89e65b6b2abbec8451498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e4364c80e5ce7b454640a536cf99c79c3fad36dc4acbd3f662fff8a83b7fdf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b61de2d2af68c0d080ad3720fa8065070b9ca4c438774d84ac99aec1495ee30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78a2b501faba0c1d41debcd362766cbd70d58aada24fbc84052aa7ac9b513b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df82b879de9088aaba050e5b2400190be91ed25b3bf30d878cc11c6c4dcda4c9"
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