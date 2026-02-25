class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.43.3.tar.gz"
  sha256 "1a13a47e55c7c89ef3c63fc9ee5634b543b3e859acbd970851d5539e7ddaddcb"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "520a585cbb67af7f6928e372c644d30e23149e349a306dbdb7bcd432d4f0e6c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90c2501da475086be61a2fc0571b3814c7bd3f3589bb3683f37ecc3f61207e7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b2f4298ed8ee18d27c351da264f5bfc0ae358eb2ead41f19e7575ef04e37a90"
    sha256 cellar: :any_skip_relocation, sonoma:        "612df8912fa9e8d8014f467542ed88d2acce715ddf7db62f91bd26440a313064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e4bcf9c6313c4db8adc31b9b735c206fa0bbe69b0828203da022cabddb9f4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0369f8fb3f3991efb309d3da123bd5a863bdb345df3cd188559cb54d66f3dce5"
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