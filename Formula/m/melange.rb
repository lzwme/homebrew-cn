class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.30.6.tar.gz"
  sha256 "292e872103c8fa85d73ca2afdf88bfc037e8e0631f5698e650460ae923684e87"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaf716a1ceee3ea499c07127462a05d34b68ec3e54d79255dc84936491acef28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "559f017b8f72897e4b11e85d5a8819113741750ff87ef88b11d301544c9c45d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fd64744101bc19c2bc1a00cf0c4b33bfb65fc78a086494244e8e6234a350c4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "09b8353b5d0cb0b1855195a3c40bdb53c621c9fe26b537348e5f66f49ca6a917"
    sha256 cellar: :any_skip_relocation, ventura:       "4812632f6f772befc2aabf953c1cfc3b7df9f39a7e779a5cc6e1e4148c79130c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83401de86308e0ef4e3c78c2fd0d75a078ab770954bd19e7e00b2baed56ea55e"
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