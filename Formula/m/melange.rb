class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.34.3.tar.gz"
  sha256 "9dd03abcb159540e1d4c6db516b25a45f1bc31c006be320c40c29a467fcf889b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c68ce11c2990e4b9d06ef06707fd01c570c5822bbda47aec0eb8686d759fa15e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e279e7ce84ecaefbcaa8c692889e1b3580afeb4827d072dca59d999ce648a55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "130bb77d3be7a542bf95cb2554637f61fe9488a27855e9721177c5d94d87c381"
    sha256 cellar: :any_skip_relocation, sonoma:        "2950a2d905a11419f1dfb758da6d0ff117b08febf941e2a4bbd1dc380619b0a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f1bb6f9198037fb3920f2a5d92f67541a7bc64a265ec8baa3e90ab4464c63ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6580f24e63f6cf24e3058cf293ec2ade59a5167f8e0396eda0bd1dbc1cb1e935"
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