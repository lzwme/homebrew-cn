class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.30.4.tar.gz"
  sha256 "383a5bfce483cfd42412e0a2b38acc64b737ff3a2b4e8b6151eb91a06105aa84"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "268aabc1b19e4b29b8381a9665e36d5ac430c89f6f54d48640492efac5d06e50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5385a6882067bdc70e05a42e70c546e129bb27229637f1e641199dc46dc4a733"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f3a292432c525d4e2f21d2e5cd9b7eca5b44f56e302a33875b9be3a0d6562b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "42a2f907fa9670456be6b0536d58037d9fd7f47f5bcc4cfb5fae4f3c6d9ca6c2"
    sha256 cellar: :any_skip_relocation, ventura:       "5156442c3e21f3c65dee4083b55d14d88aeac3282b612b6e8f142c74b6d680b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "047bc47dc82debde44189db0ab5c912a6580e7b3fa7e8d57b4cecf2123e208f1"
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