class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "10537e316ad518d7bd9cd8694704cd102cfa5c598a38cfef32de16cf10d32449"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67914007090446a061d0699849f90f42c7a3dea72bc753c8874d441cb218b9be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d416f5ba203d8ac49d3f90e8577a557bd559b1a3d5529c293281710841c10d3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11f226fc79b387df9c17b38b0837389b4ccc4f29620b457c1f6701c543bcb60b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3040b3d716994ef57e4987717cb5b42173f91355aacc7dde09a52b412f7138f"
    sha256 cellar: :any_skip_relocation, ventura:       "11ebb32b5b3d9b362adc5cc38428d692234bda8a5c56b4776f296d717b2a976d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d8530d24bd1ffcee1fdea797a376b25511caf5e80b4e8992767cd2f5273ece1"
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