class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "a20e9000cce5152a379c718e1c22836e626403acd30bea608cbbb1a18fc84bec"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33cc4fb26a3b4d39631e859a09cdbcf7825f587d76eb84ca6acc45ce3193fd82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f08a4f02bad20c9f53fb9c4f95ccfd112da7b04dbc7add1a15847b9d922ce48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a16a6ee66bbcc42eb02a2ac4a14f56867c18a3afea388139aaa025952b7306fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "72df143bf9fdf4423bd9a5943847db3a1f58001813a78ccfffc2d0f50d3306bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e4ce35961eb10fb5add85bfc42494ec11485903774018b7deba9479c54f87cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0840b0ab98a56c6c671e1ff5e3e2510c304950e131e00d96bc406529ad2da3ea"
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