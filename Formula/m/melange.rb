class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "b65197fb10babf9cb3d56852940ae624b9e48cecfb7cc8893654405d7ec6dafa"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab67f76d239149a06c22f616ff81601220c9105a3459ffdca49cfb27ea9a5b6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5929ee8d25642c4865f3f140804ab2b9b264a060def11141d0e187cc8f787a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c47451877a47e03b616d6ffaccfd867c86176fb62450e7b3997233b24edb4454"
    sha256 cellar: :any_skip_relocation, sonoma:        "988e2d81d4a1807831329414da6a265154e1f44a6f6ac49b1a85818c7d44ce7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56765b56b4ac72baec145530bf3895776976050c29fe0538ec263652862b17f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18099d56ff1a3ebcc6d3c51a02914bf974daa7f0d5cfaaf0572966230e5737a9"
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