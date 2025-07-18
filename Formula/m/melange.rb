class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.29.7.tar.gz"
  sha256 "4eb07c8aa49e3d1040a88312d244b3d46db80d9b471523cb29e018f8c1b18a08"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ed93432248bc76ba927c5a27963772a7056c35facd02246828bb827b085227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8f657ca266658394fad4c60692c163fc60e090f62e8bb81905858ade283089c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e00fbedf4c6451455a0880afe401291f6a7b686891f2bdc5c4539f13147369fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "894541501a9abf0e0c5f87bfaa15a1899a4877c6e5fa65df3c7da3ddeb2beb17"
    sha256 cellar: :any_skip_relocation, ventura:       "2bc078e57eba45a1aa5f8d55725654070340ccb6462189f5fe2b8067410cbc62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07a95157e706f217387ef42de37236b64a714f7b23d5986fd1cbb24f001f7dcd"
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

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end