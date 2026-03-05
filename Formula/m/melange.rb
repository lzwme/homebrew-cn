class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.43.6.tar.gz"
  sha256 "320505313a4ae100fb5c073fff4e6f654ef9392813eb30f5979e476480a54044"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50f96c88402156e95e11161b52071873857d40775e001dbbeed6ef8134a293da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67c7e39389a5b0c69b3d976df3414287b40276a47c977ded7c07807d577f233b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9585a3893552997efb3b0c8f6d16a2e73c390f8ffb05c7ecc25a6d643b079ca5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b13b37061388132457d5eb54373c7919bb79dc7c60c2619883e51200cebcb8a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f4000bb0ae0f7bf48e97c93e3a5ac541c21e03ea9c176c1e97d9c0e7714ce0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fc548175d4283c34e7180082f537b55f9d671ac9e3d0631964f43ca84725308"
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