class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "996aa605c0b1a177f6555cfd14835d96262c14dc42ea24470958a0b5458ce170"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca74281d58a4fb6aabb09fc39b599ac792e7180423cdcae88ab7a1b5a06fdafa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "079ebd26e0f4bc387ed334d8ab776a0a700330977981c8913663c5d3c8c1b18b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9c8bffcd187537dba510e6a598ba54cb31d5eb6b4b644401bf16784cbf78afe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e03fca674847f43ceed423ca6425816862a842448e720f0a2363c03819b58528"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd13fe7b3e918d39ff09d2e6e96a425fdf3511ddbc609d24f2a3b40e513d31bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "798b823857490e921d2cf1a621a29a83e9b72cfc6f39582c84b43477812ae5a0"
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