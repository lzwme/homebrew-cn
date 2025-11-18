class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "21fd8e1297c1d86988337bf49efd0a1ac62aa3a09565019e7355c086b95d0b21"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba502313d5ca157833c2728827b6a18ea71221bd2248597c9a3089745037ed03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec8d88c0de88c60d7e096b3b189fafec4032241662348d35a5fb7b89f34231c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf93b642286c39cfc1ba4e829f201f167c47a74997de5d8fb84811a1fc6cadb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "634c12d4b6122adb19b53b70e23851fdcde5dfa1422ca483192952473f842126"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db9320abe69ab5e7151e845510f54f2ce4705c7bbd94ce70992c55d30a1e40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "266175435a23a0a5ca85e5f4ce6d8014a5b2a2a5c3bbaddbfa3710e5efec3c8c"
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