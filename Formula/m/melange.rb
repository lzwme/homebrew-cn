class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "211d2e4c5fbbca9283757e95bb21de1644b13fd62ea8b5f8456348c4e3a6e0ed"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86167a9a8e66e0b7af24b5c39e3dac9cfeded7b0d6a516bebab5317179a67036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dabeb22a3951df7aad0ca63d5452328fea24390edcae22ad9972aa2165e812c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73edb2b8fc07b72dffb99e10912409e34292dc3ed7ff5d0a7132e775f57ceb74"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8782cf6909c99cba0ddd9684777a6653c119b4b476c29a47c87a02b0bf335ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "930f1e0b63988e6ab1ad539783b912617d7c9e079b3c35fb816a6bac9f757490"
    sha256 cellar: :any,                 x86_64_linux:  "e98308a6a2e948e29eefc0a39fd658bd7f99837fc6a852569c021a250ada0e27"
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