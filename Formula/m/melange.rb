class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.40.5.tar.gz"
  sha256 "2994d67105f73634eeb1f1fdae93bd828cfb54932d0d0d473b8805ead5f2a12c"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca83436f6e1541287ae2bdbd031ff68e91082efe12dc0b134862eb8209bb5aa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ebd110df2e7a0b7573fbbc8bce7e2ace4420b312941567032473ac4220c68ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db91dde12118268b15126d6caa2c31b4a7b6c7dc0810092baf5769c614d92425"
    sha256 cellar: :any_skip_relocation, sonoma:        "17e975afc9e58ab8be025b2f9e81ea8d760abb91b756c37dbf7bf9da86f5dcf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8486c271a07c57bc904a60d4b8054b52ea6882d810c228aaf1cfa093466e72e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4c231be7342bb46b66501cd0585a313fdf6fc47af64ba60c38409a1bb51c0fe"
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