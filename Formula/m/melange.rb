class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.31.3.tar.gz"
  sha256 "8080a40279ba7af6d348c6cf41ee864ed887c612658b78351ab73b3211ef9f23"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55af7dcccb9c9e69c43619616095db053d2ce0d0ef164d641561ef997f641062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c0fdf655be390affd6d51f40766a8d5a67830902277f06cc8f226fdfc954b6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07fd84acb622f6a7e72e22bdf3985ecb8426901d2f1fc7845208d5e546d6f923"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5b2e0298fb30afd686f60fb4806938d5f336dd8a563382689d989057d2aeef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "00c48e088e174e3a2ee737982f2d9910785ab43885a6fc8731c27409c3d1ce7c"
    sha256 cellar: :any_skip_relocation, ventura:       "6a64397f2af17ec22e1854922fe785daa6f1969d78befcd5a0e4fcf05ef5e60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ddab4b62c68b8c18b40fd9d8a0add0b5e23c43c6eae2549e66539a6423b1b3a"
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