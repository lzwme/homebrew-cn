class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "53f22dbd10e5e05b37ae117c57e1ab6729cd5bd2ee74533ef6ae6ff04eae432b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbffcae7b119bc8d6b5a0e945c58340e2fa36b18895c3d9cfd2c7992d9925753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8a637c88b42e0e7f6504983ccd15d61b6c250b3df3d5fd78932f88e739f5509"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34d12712c7f80b236ccc226a02bd480bd8985af0554dcfc900bc400bd1ca8a27"
    sha256 cellar: :any_skip_relocation, sonoma:        "5177da1adeeb6478bedeff537582538593e4dab73930eed359efeb63b662ef68"
    sha256 cellar: :any_skip_relocation, ventura:       "670e12d9e0f8fe38c5ed469aac57f1086f891492869241a96d81c2904332c5d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a57274a7caa5e7a205e9e59d0bf3f05a0e908621ee3e4161358a247813e4f5ab"
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