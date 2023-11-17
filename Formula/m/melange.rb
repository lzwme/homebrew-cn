class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghproxy.com/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "b38a6d5e555c4392bfb75119f5323abab28b759810893391350192aab0f46d4f"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39fb51473daa4a50ab41b1145c11910f9d937ec1eb622b30758faee41b25d83a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74f9990ad117cc44ffa8d36c502170c1acf823955bba9b9df7f1d1cb68efb79c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99a74dc51faca0834fe71e0c201c915cce9c1a4fefbbea763db2ef1b868472d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e24fba734f8e1f0fe9a040c51c72533941ce83b5f44534e987438c96f57fb0a3"
    sha256 cellar: :any_skip_relocation, ventura:        "7845973ad44fef0a6ffb34fc8e9a97c50bd43578ffece8a8e093008e9fadce3c"
    sha256 cellar: :any_skip_relocation, monterey:       "30fd2a1cd705e83c94bd8f2f0cef0f2a2e309dcc4cefa2120bc159fb51fafd5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31a28bdd58892cb916a1e2e8bdea21b6912baa38fc2d60e0456be88b8da23a11"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"melange", "completion")
  end

  test do
    (testpath/"test.yml").write <<~EOS
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
    EOS

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end