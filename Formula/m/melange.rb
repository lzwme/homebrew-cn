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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9fe3f129f0ed7cfe9d17d8f927760f6e4f00137ddecea04700f674e740f0c95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c5ea15db5edea1aa17bc06a3d70602462b57d8b1e1949864c610c4fc8536913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6251b2423d19bc66cf1e3890fd4d56c507b0c504f35acf70c6a880cf6277ba4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e33d47e1a7da4e13ec4b2f3dc3e1a58a746ed24d765b4362ba3f97c12bbd506f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db630b06bf11ee53e66d1a6ed856016a44df45e2b1c32895b462686382b29b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9527402ced6c4b7ed3c045ba94924339415d77bea721f4f1730e23bcfab87dd2"
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