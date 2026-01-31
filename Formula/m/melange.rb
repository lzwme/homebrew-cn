class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.40.3.tar.gz"
  sha256 "6a312f4cb99ea783a8a420c6a4e9441aa3d21fbb34d26b06047abc2c31f788ed"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e92de6669f717ac55e135fe813d2468a27ea4eb6321edd8024d1f29efc54acb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6135ae6dc29128f7571e761923b2682ef2bd652c58ed359681fe97cd867271e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a908a8b89a775361992d01181aa329bfe76eccb909cfe463acd10beb356fff6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "96b732efefa789fa776bf6d842aaded392173acadec239d69fb231fafce54781"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02a03d0e97d79d3eade3bb6c6769ae72060f0f4a847bb83cd545f10be4958a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d558516c2742e5ad1dfc73cd6adff211a3b09a681af0cafac6c730e75f4258f7"
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