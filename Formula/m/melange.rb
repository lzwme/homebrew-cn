class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "dd1ae0fb0da279d7c410b1688ac090417fc9b2a0ba6b26e6e0398ca5502f1f08"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c81110b1279cdf3254e61c3e998b93508b06ee512680029400f5686f91af0ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53fae19c2d6cbe84618731f1327ecbc70bfe41e6e405050a671b64460ff07894"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3287240372dff391e3bc0a8a359920ae266d2918ae7bf3e70a8ef5be0583a2fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "60416a2cf8d0db4b4284e1a72d8a9caa6a883a34c98a22628354dcf5618eb709"
    sha256 cellar: :any_skip_relocation, ventura:       "434121ffab849554389b52f64fa4ac50250975cde8ae87f123d407a0b567b31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a42cd57570d08a0990039b6822b531d0a1b5ab728b6c90efa808234fe68abdc2"
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