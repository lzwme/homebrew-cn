class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "1082540294f294f4c0e5a4255a961e88fa3335bbf7f910ca5a49790c6829e364"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "813be0524b58b5b57f6646b5772cc23c8f4ac17a3a986fd28b1f23bb59f97530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68826c9785054ff988d11d6910f203181fe608633a45dd79f10d3009714cde88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9920140d5acd1bff81f47765272560723ed50ca5a69e5bd7ffab644ae6de395"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec53274e145eadbf4691e27d0274a935136c8c430539eae5d0fa4d4892519005"
    sha256 cellar: :any_skip_relocation, ventura:       "c9304bbf76859f2ac3196d6f09115c67b7473fa1cc30a720ea7a6add469adf46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c12734e5f2dfb08ea5204003e337bc6624cf0a99c6a19b177a6db3ff362de46"
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