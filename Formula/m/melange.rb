class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.50.7.tar.gz"
  sha256 "309ffba9fce4ee38ea090cba1655459916d12f94f90c1774ae201dc5c1565148"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ce9f1f097399c3cf51d9aee39be0fafc056c69d49ede8f12c90675ad42ef8f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5ec179406b4400a98124fc0d43f123e86de056892fc0592eccdeea3d8a140f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "158dd5900574c75186398421fe87e2b9d50796109cfed82eb3cf310fe0dfb12b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd11ebc718d863e08288d237f85965946c1361e4093feab849d45ed8a4326c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8c64dbeee129ed49e8c8270e5f7275b3237ea6696a18da1dd0bde18869e31a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b5d15d35606f05e7d21f6e18dd895f473f071052334fc49029f9aec7224851"
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