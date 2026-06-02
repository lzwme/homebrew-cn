class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "7b1e5f6ab861befb1f1d91ccb5189ab8710b01c160e2e867914ab236d6904a9d"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "660775a266d960c81b4f1ef4403a71e7695bfb004560b75d8e416658d1ad53cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "906ec86f790bd9bc5fd4e967c442eff2c537bd286af06bca299709dcc2bd7f67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fb6228d983755260c58d6ac35885616e8c427558ffb3775bb1c69e9fdd5448d"
    sha256 cellar: :any_skip_relocation, sonoma:        "045c95c7f958c4043f57ca3a9d9faa2cd277ff84ef3ce02f0c1cb170906abb70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ac67637390491709a03ea8db513358f7f2a97b286f0c13bacf1470971c5ec9"
    sha256 cellar: :any,                 x86_64_linux:  "760957d826e9b9894a37824c0ee805235064c780255d78ea1cd7210fb3be83d0"
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