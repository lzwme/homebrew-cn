class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "1c9936ce0581448ff1b4b310efcedeef3b0440e387f52ee6520ee9332bb9b926"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8338f39ee265293c142a29c16603fe516c1232461ea99854ee293b8d402db8ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "476c7e1232f8b71fccbae226bc63005a6fc82fea79b72ae5519f5cbb53630aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c6932c3671ceac063f1f63f6a28c53dc135812d3089ed8a81b5bb1baf5b4bc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5998c5752821930d7350280c3260bc85f449dab7f208b2548dc02be4f387eb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1ca0e54f461f11aea90d428faccb90e136c3ad15a880080e6fef03336c58863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52c0d500889dd310e1e4b5447052a02ef63405fd58d03611200ae98ee4ce8bae"
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