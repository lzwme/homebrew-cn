class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.40.4.tar.gz"
  sha256 "01f054d49e75f1bcd815d6a3881cd56be1c2fb6329ac6ba2de41fada2e06341e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcca2d1ea4b76afa0581d5a72af4c7500b25e57530c115d63c16ac188f01b40e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ac2239ed99bc8f0e50a1fefcfa7723c24a1653708173c3784d3e580759a02a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "952375ed01c8d77f326dc9d41f50f5a11d331758979c5a10226b46e7b7e71f6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b6dbf933a7b9d49ce98bf48f5c505321f38114ffd930a5584ab34e492a74b13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cc599ed33d4d4d2af37befb29be5e846a2f4543eaf8644be55e804f18cedaa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a689ff4fc7d8d91b3795e1048f4608d9cb5fb68da740e83b0e204bd3962c6cc0"
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