class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "f38e0212f7ac14cb0f8b1e906086a487fe7fcaf1f9de8a1c7c3fbce9544b2070"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99399ce523043dc125a09b9522074627eff87af9b3d57d1fba0505791cd05ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "862bdf3fe975a3d3bc0eb016ab1cb8f85de4840a6404b71170c7bdd18b9c10bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efa14d9b57ff528c4192b97e25524a392f930338cc3c3ff62ca7958c39b7383d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd3365fdba020656a27b429dadb08f9a2c5a88ccc6a9a47362878504ca519c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8646ec9f1764dac43d44860e4c71417364013ae4d2703bdf21bb05c5775e152a"
    sha256 cellar: :any,                 x86_64_linux:  "17930a68c010b8a8817c26c90b4eebf4d276c5fe1b278075689a5d8189da9331"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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