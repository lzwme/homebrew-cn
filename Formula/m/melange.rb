class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "332826264d8e895e5aa77d6e2b6ec146d551b88409f1e1b7d72d3df1e682d03a"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77a5e545eed1807e68d345d974aa7c7a74f3104c232bf045ab11e09c9de5f0f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c830ad44e12fbce450ba2f1aa56843d454c958e811bb812e62dfafe681f42fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f84d5f2cbae95b20e3ddedf2d761ae468e4f64661be0b4bb6ffd5748444904"
    sha256 cellar: :any_skip_relocation, sonoma:        "b796f5b19fd30b1593a8d0a02c64269e99827b635dbfb8f194e94fad596b7828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2e69d19a4b5873cfa29414ca8a8f3af3084d6b227ec42d8907e124133a7c21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2ce25ed525d92703db5907e41b200968f1d7f31e829f16cfd4ad76e75429272"
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