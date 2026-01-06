class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.37.3.tar.gz"
  sha256 "ceaaeb5109844f83bfb8031d4df46aacd787bc2f1a2df736f9556c65c729c84f"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "126bbf9a670e0d52d060f68f7a0e3027e5989ec7d9175b1b4550a7f7afc50f14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dffb6b1d3a10b4efd7abe967d259323d38a88ebce73fcc038fbac4adb8590bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "327bcc74d46a111dc3a89f4067f2b9cfd6a1647bae3df12933e56198a7de0de6"
    sha256 cellar: :any_skip_relocation, sonoma:        "af83112fb97bcf99ad49a23de7b12d0afe140799a3c7e79837c1fc302b75a20a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb84e511bfc212999f2550e856cbda4d4e42576df04b32d7207dda5e27dcc42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d69b1111fee3c7c8d78219a474e73a203b996240d2027548d4920ff1c257e210"
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