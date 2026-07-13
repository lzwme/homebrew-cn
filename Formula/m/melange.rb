class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.56.2.tar.gz"
  sha256 "aed6c0b71653a59bd8c657d0f0ff9991a73274cd2ccdf6d951019a286553c873"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "246262edcfd59b857196b4227b323ba842922ac70046ebfb47487a7f61ea134c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46b922f150cdb266ef7786bcbb325f85fece6006e449058c7054b5ad8fc7cf78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9646db87a13c602723acba3e752bb3361f39e3adb0d418858c7e90aa3e4f0636"
    sha256 cellar: :any_skip_relocation, sonoma:        "307ba6b33f818b325ad1aad2dd326427ebc1213f5eb84495f48d2ddbe84f2b7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6ca203cb4bb4c46717256e5a7cb7a9cf6cf5bc8660239a10840387208096805"
    sha256 cellar: :any,                 x86_64_linux:  "c8ecd49d1ca47d8405f72aee02d6cebdc1867e50c41426199fe27594d3511a5d"
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