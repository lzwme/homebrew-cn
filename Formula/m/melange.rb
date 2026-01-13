class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.37.4.tar.gz"
  sha256 "cb96c228a19c935d7bfe156b493021017542f878b7b089fcb0678a581d2b0bce"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ab26e0a48e9410b686852c6afe7176c58378ea1ae3b45abd6ad3d079f095cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44a407d369bfb0144d4c268017298bab792f9fe782f1ecf86112a573af479142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e048ef4135d53d0ab13ea4358570129bd1cb4d2671e82f5159914b199791647"
    sha256 cellar: :any_skip_relocation, sonoma:        "802283dfb57da03dfc5c61aa25d4f0f0327d53b61f561db458b2b3132e19ef42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "713667902c4c4d27ddb0502c1b741e1dabfcbdc845600a19d2fdde2168d87a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2748f5f64b5114c1264ff5761018f543d086a352a5fb940872384ec65fae1c0e"
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