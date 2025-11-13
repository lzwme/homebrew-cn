class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "6c131e7a2266762b841652910fa4669415351cc80b9a2d3774aa04047f7d4eb3"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b7a61773cd6d8d9082d376fa0a1f42d257d37a196573f86228c57025a26d1ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0306a8af53c0742bf946d88f371e30b5bf28ea29f8166e615dd3b78236a52cb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f26542d3b86ca6479c40d73d57f3cbd1c592a4bf37f280796521fbe80f4bfd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "970ef28db675528241bc6b745389d10f26d352a47e9ce16852c3f4f55ec78a4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e21e88941c886c0e39dd9744b3f74ac263a3427ca82e1bb6134e634c03fca79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ffac23ebc26a51215f9bd1e60ee0d070043914f606dabe65ef07c09559d58f"
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