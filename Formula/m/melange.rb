class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "dccebdd99400d33474539a4d8ec253483f9a2a1a4e09f0b52d5617a971280676"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1727699d1444781ab244d60c6ed85b3051a1a6c3137b05a5bb2948b674bdf73b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c801f8b2467d4edce075b97bbc3ae90d27b5ba6074a3af562c2dbb46e5dfe475"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e1eb1d5b79c31d5e95aaca774f6a7ed7e37308f4c35e79dc9fc1ecd5709a47d"
    sha256 cellar: :any_skip_relocation, sonoma:        "60c15f8f9440c72de8dfddabeec6f73c7df9cc0583ab86bbef509a307fc0aff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92543f8d2f3c34d17b09320d7c67f00b22fbbbb7e675883c009b7172d3d2df92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b1ef31126517c522d9d8f635b15baba639f672864f7609e6ad02e9dbff0240e"
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