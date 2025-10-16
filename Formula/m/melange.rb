class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.31.8.tar.gz"
  sha256 "ad4d2ea1e9ccd481033d6b0aa977067f2613b8f394e010801a5e87b6258e59f3"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fefd88cf0d78e296a21fdad35b4a6fceee9a29fac7d0868af5ad0971d189423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b923ce353a68d43833d704613af1086f60b490a3363c78e667e6e3051992de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d39637c0d7fdd0b575d8720668fbd0334d263a4852b0970fa172acdfdae6519f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1bc7d50f413a906937a1c1a7290813b758d1020c1ef5d4ba72831e651332e9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6eb787ac31ae8f9b44a38d4c729fb99087fc957533bb36aaa23b08c3881c1c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6d9e2462adbb402cb0192a879faa38a4676e3e0c429092df8c37baf8ff2441a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
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