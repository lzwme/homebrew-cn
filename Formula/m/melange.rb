class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "1f17694f1c71b1bc02d6fb4b4cf864de1d7cb8e7f8f21fda01aa14ec595222f5"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22846bdab4dd2e9385897d1730c1baf77896e1b751d2b84580b0a5bf661bf150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "948f22de7459ccc26c1667d9831d8e0ad8299da8e8dc478d1ca3ca07da61962a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c30828bf9f4439f8d976ad706a3e3695f516598db603de2c78559e191e898fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee1bbbbf0ac4548fcdf5b72f0df118da9475c2c17226d4af646ab8636dd4dc17"
    sha256 cellar: :any_skip_relocation, ventura:       "750bb550bceb584e18791c52baf9bfb984fa7fa09cf423a29731d7a61c688157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53ba7b96c357e6ec85938102cc9ff5a1fa04233427b58eaf56c3f86fffe18d08"
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