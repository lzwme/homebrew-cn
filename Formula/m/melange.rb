class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "8005365665025bf65a9ecc4e61b0abefa3d52a87da836c357481311b292dc6af"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a0ed3cd540672bb8e56f0f3e69df3c70bdb6641a83f25308a1f3367efd40bc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25cb201fa9d5462254c846325d92d016e6e1e86d8f8283ac7f4a9ca30ae002b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c937affe1b90bec38f030f9ed7248101ee721663981cba4aa7f77eefb4f1908"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e748baf0c4b2af38a6cfe6b090de4a81104689fe86a9f589d70c2f9507fc307"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ef7aded6b6e6e985bb6c0c9db3b7baef6ae15e15b434b0f73b7899aad86d61c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6921ad621dc02567a878201d279aa7633a10ec33e5168e04d7cbdadf344a3417"
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