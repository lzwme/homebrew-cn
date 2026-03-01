class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.43.4.tar.gz"
  sha256 "dd1c7bf859fc445bbb597974dce6e0a49b54c7a13cbc92c433b3010c04916220"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a188d00f3a1360582fa9256170d65a6c3d381ed6f4b6a7bca11a14888230379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329b545c5adc5ad7ab915370e3aa33d203a5870ee8119f3df59d77935939f632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97b0bb00bbe33be7ce45ee3264695ffda3a4b9818c3f5ac644b84c4992a44cf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5d07bcfe7c66aac0e63f0832491852d08adc3d460b604761da9e74e355240b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f11707d4efdb94b0d7761af43ca99104db804c74780b21bc85b8644821c6ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c24e40bb46757d69f59a74423a4d10975fabd36035d9093e1cba62c823b034"
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