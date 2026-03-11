class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.45.2.tar.gz"
  sha256 "04d1ddc658a8e7acc928ae08252ba753e886e1bbf5dc2fc495eb83d2a366dfa0"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c45917f1b41c4d4ccc2796842401eeb9675ffea7c1910273dd572e1fe8bb346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b512d18a878b5ed7c0e4898dc55d7359219145e59fd1236720bf245cf2f76a4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a49e9182fdfcc3a65d3cc0f673ced115b823053d55f3bc506637a55e96976ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "61ceb458685709b55e57afb490f3ef58418740d233492a743e96785f2fd71662"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91d23036f984af376e200916351dd2f2c5e529be38f4cbffd25d83e9712f4d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0549f0c9027dc9a3b73782d971aa38deffc1f094844efcf33b6455af3ccefda3"
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