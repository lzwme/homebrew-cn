class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "21e83004addcd40f13f7dcf5e43543b24964a196015a5f3ab9ba28360bfd1093"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ef21e0e04f3851336d467a6bd742269778129e6e9426ef7eb49832cb47d7324"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2a60ff017ac1116aad9db45c2613c2d62bb08890f7c89cfa82e08774e6484dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5282c416607ddd67ff85fe650381626bc91dcebfc071a26e95e09f4c4009e5f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7cbef3e745cc0291b6581cae5434a93ffcbbb281bc2f4606dc829f4c28f84bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5227914de60d0b7c8667bb5c3445c4cc792eda9219215f6620b7077000fbea00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "382d257a7de4ecf5274d495221f46f3a76d37deb7a2bc17c8b5c906e1c38d40b"
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