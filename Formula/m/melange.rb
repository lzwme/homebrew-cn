class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "c325b94186fdd2bdca0e22291a4e5b9307fe0b99187eb383e950590ac0380bbc"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bff72d3e5402644023928756629cdfe9887db42e577117d0a8417ba4fc3d5eaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb9400b6668019fa753fc9d0a1c71e549fc229a547501ccac2282c244ac33531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f3a65a2b4a2e77ee22207b7a3709def572f93291e1b7ba653f9d828e9c129d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d024bfd45f68d958e6f3d54b04c64481cf3246d8a0824ba6f100698dd66dce16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99d164227f498a2e266d81534bff92f7a64b3415fa8793000c0fc2e3bf8dc0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ec2bb60fb3e46a76c624741eedd8524df143144ccb91e879a008f9177ed91f"
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