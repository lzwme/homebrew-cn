class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.53.3.tar.gz"
  sha256 "d0692e9d8b7897e4ae5cfb2681d191d16ef2ba06792b2ceb2acda15e0f5cace7"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0ea276b0a0b58bbc95f2247657ea63deccc00be7a42504f67b65cba45d932f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e796c35082007b89b3a80ffc9ccbe0b3daca727710805e7da529422ef2ae65ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e6180568e2662ae3929265a94e3cf212dfbacd842760b983827c2e33e43fca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e819ef1f7ea99341a9c3ee5e6154208ddfe0f1ba2b7a3e573c30f934c47dfa98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10635463cea92b4f61022d8b81b1b8dda6c20a98cab2d2197f7b286c698c2426"
    sha256 cellar: :any,                 x86_64_linux:  "c21b775bed1742a8e7d026838933bdbdd0cff55f2b34118c76db3782f69db713"
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