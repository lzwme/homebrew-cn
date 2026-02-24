class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.43.2.tar.gz"
  sha256 "4afda6e4cb272e531f5f68cf09e1985117f903a642aec543118d1d472eee2377"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17d0c7cc4ab5f31870f8225e6e208edbb5ab7e74b7b23d16bef41d7a6905af40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae5660fd86a39d0f9a95486d91ede224a946d5087ee3f9c976e93a04bc097130"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4af00d55fd66e0881d05eb14325c04c89a2a2efe3b9d7bee37ee564ec06d6c31"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e9a7eca7c1c4173757376d3c48d723a0725c5b18d89311c2bbdc41564a1570a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5c57b40b5a325b3b3d9dadd987982adb95c21300accedc65cf894fac2a6a10d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb24a28fb187a62ce2a7afb524657f4f257f8b28c79d04af0dcc0dd5e6a6a79"
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