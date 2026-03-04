class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.43.5.tar.gz"
  sha256 "aa43b5c17dc2ff1eb730062356e0f3fb029dc18c056d913626f66d34879a56b4"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45fe75a47969aef3fc1066fe8410775368606990b0dabde1015563bb162640c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddf7c0abdf02bac47fc24651f8e7fb2a9976bb008cd9f6ab8cc7ec9caebc9403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "769b90c86337b28ba8a5c55948e9b50cfa01682722097d79efc09aaffbea8e55"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbd438f8443b1abc769927854b40248878e9b230f747e6e3dd22e332c5589c05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddc57294988bf2e74d22aa60420e3b5eb9fac8de67708cd01be4c078054d8001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b352b192c66bb6c02fc7fe678428a7330b7a3e5d8ba38599c8affd8ca353555"
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