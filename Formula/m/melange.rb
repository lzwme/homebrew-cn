class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "a52b502091149b9181ea21e012dc41b7c17ec49e6cc687e969e0af8d25b85b9f"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8c9150937e686e3baa506df0d4d6fd599ad92e8e5a66e75742d659b3c92c2d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf067b6631982a24e138bec2db241d7dcde406d763b913370462a13156d3ce4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "805e69d9171948b64f1927afd99acdc7f4997f8a976025269b833ff985fe930b"
    sha256 cellar: :any_skip_relocation, sonoma:        "825f09b0512dab6aedbf0ee521a37062b12b222cc9f3576ea71265b8ab9e44b2"
    sha256 cellar: :any_skip_relocation, ventura:       "b563449294f96000f79b599ca9488c4c02a0bb66f20b17151458d85837c84992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0fb2615a66d3728c687036226100db7a9fbfbdd599a904ef8cca746af2a6d78"
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