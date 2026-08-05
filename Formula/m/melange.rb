class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "c07472b6de5db0da8bba771a5f7d22f9aeba443d00f5299a65173e486791bb13"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e8cd18f8a88f40e7f59ecfdffb98c2ad4a2d1f91c5446e7adb1af92c99cf59d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6da75d997eba1900b9bc1c34df447182b1dcd680956532d9b3e99363e3e2829b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af5cde8b66c7af3496ccbc639f824f3d0c40308782c703306d60f80f4e89a542"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5b896557d663995222dcbd3cfe318fd9f6b2849232d7b155045e9ecc28fc236"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce234891a61c1518963455c682baab0087c9f7be3c94ff3145990be2f7cbd94b"
    sha256 cellar: :any,                 x86_64_linux:  "99caecc75b57d0df777d1f37f6fc11abd779480ea2f39f3f5338ac5834a17843"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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