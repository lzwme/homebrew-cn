class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "4d787c4696fe265f7711f70b0cfc7889ccc8dda2b26dfe6e8a0820887a06a602"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42e9b043d16e777e359bf18a5f9025681ef87c82be7c3a209456f5b73c170a01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38cf0269d61e837140bf1c78ffa4874dd41a74441e629941bfc4f7346218a254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e0d6727de541fae94937cc6e8a94da23e10c47473212dab07689011377a9e3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e48986233864e819ac08f9bef3b5a716c4bd6dcd374b4083749881d396186725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88980319f3270c96644272837d78f3b9eb2014517fc26f79c85ca31475f36e2c"
    sha256 cellar: :any,                 x86_64_linux:  "7c10e049187246d8af6143677ad0b5deafd9230de6297073a2684c1499e16377"
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