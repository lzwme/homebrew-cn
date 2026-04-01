class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "fd16adbb2f74983c1b75355679e5543290831af28f7b00a25640f15503b03eb3"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dadc9fc4d244645ccc9db608f2160550c195fb0b6f295a5e1eae3d28640206e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25278ced87a43df084d47dbdddeae56847417cf3b43f791bd5c3854e3bd2dc97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5509342b79a4e74a2a576b4aa839aeacb01d75825a4811cfd8c885b2248b4c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d464da22e2815c2d48ced22635eb7a9080ea2bf3443e82792b3e2d44c18f5d0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c55286e441c53628289041a55442a844dcae325dc7501ffd31e918162a7349ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea224b68d79fe732c6bf6e05d52b3a62711a5df84dabc122eeb678f6d2557064"
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