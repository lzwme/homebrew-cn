class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "9227d48b3dd7efa1e16090544e167e1bea7a9bbac528b72453651a8a672e2d6a"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "deed01aed283ed501b3f5b053abbc2115b46d9667da4964778b3070094d7e2ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19c708e998568eec8d624286be4c76806c8983f0fab8230c06835e7bb798a657"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9347c1d0084884a77f3d8096bc32d71aea9a330edae848a0178e6297122f5da1"
    sha256 cellar: :any_skip_relocation, sonoma:        "22b42bdafdb6a35c391248de51c58c7d706fa0e2d631c109610c50cb341e6945"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7054a9cff23bfe6e3d5575049c63e5b4314b9dc7c3861e6ec10bc0ceb91001b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc26898982fef07b6dd1659909cd58b1a9156e3875c50d8170996bb30851a827"
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