class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "556c12d2c885260c27bcc1d6d22141a80e3f974c4b509c085777c36a4e737d31"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a55064ec7700fe93c77a49d5ff3920fbf31594b91a82218e95f3b4d9a378c8f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdafbc6f837d7369c4974a7c724c202c61b51a6e0e6d73eee149fb718c4e8d7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "773453087bb2b94517427469171c0da4153c4d904a6a7b2882d5b46b4971b1f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "406a80bf549015bd688bc406a1f25b0c0177c31750e05615efbfca8942eb8b31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cf3e5eb1511d66d1738f74d3dedbb75b6a54fde5b066db1b0cc18af499c779f"
    sha256 cellar: :any,                 x86_64_linux:  "db6d928326d011e62bf429aa3201863b5fedb6695241f67793476e647f8aac07"
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