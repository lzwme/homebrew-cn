class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "ec25b99ef1bab7a754cdd62b2c25e0149034eb38f519dc13c44a273584a0ac6b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48489e1e96aaf96618d1ba9256c72738857fb120d6748483ad433e12619225f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1458867d4d6db31ed0882e83b530fae69c04541ec35cb16e0cd2fb519efc6d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80d4bed510f61c94122afeb446a4b07083b06a97207fad5870880c827365e347"
    sha256 cellar: :any_skip_relocation, sonoma:        "c273352d82412f5c91e25936712e55123357520f4265898abe5be66aaee7fb4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7368032198ff99c55fc77dbf5b8f90c4a6b4a216b66873fca6b8738284a0ef54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81763e2ba20f74adacd92e7269ff4aa8e41452b2dcc3286668b6db186ae7d31e"
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