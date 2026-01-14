class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.37.5.tar.gz"
  sha256 "f7d5338f1433b92b0a4e33d7efbee5eec082e844fe3db9dd2b476ddde3fdfeb2"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a2573e6021b8f18a0ff02aef3a6fcbac42e6b38c8a1e78a049452bd095d0e3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1a5fdaf56009bb2a3e64b8e430895e662375d8ad4149f3ac2275fb07c9100a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1266e797b8d021f2f930e8a6327abc7a24e83f8dc56fda126d6afe6cb2df40cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a58cdb9d7d1a23dd7a505efbbf5b593264526ea4f73363fdb3d7c9d693c30b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "762444218d126571f8c85019408aa4e006f269da8c2063bc0c81f2748910db25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9f12d741e796998475afa2134f7402a1b62892b8cdbd8f0c972bf9c48b1e4b"
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