class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.17.tar.gz"
  sha256 "af7cfcc8a88803d2f4c4a51d910e58aa76eb573eb380cefcc7473e80ec28308e"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01ddfe0b6df070f71df65ca6c0f0fa8fa0829e0c0cd5846d8c6948705e6d1538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e951846ea50121a10eb5d6694878bfb3d41a7f6102d2469026281a43eb40ce6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dde179ad7c0f66fa8a649ebbddef1799ea07c24e6da7ee811b7e4eabe4b7245"
    sha256 cellar: :any_skip_relocation, sonoma:        "60e5f4bfa0c114df394375073c4a9fe96ae213b8d102a483bcb63c510c734c95"
    sha256 cellar: :any_skip_relocation, ventura:       "b50714ee5644c4c370a0a428edd046166543e134647de29756988878a7e62bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e21bde3386058f476fa437f47d5f0be70bf69ea41d569b4b8f7bcf232b6ca46"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.iorelease-utilsversion.gitVersion=#{version}
      -X sigs.k8s.iorelease-utilsversion.gitCommit=brew
      -X sigs.k8s.iorelease-utilsversion.gitTreeState=clean
      -X sigs.k8s.iorelease-utilsversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"melange", "completion")
  end

  test do
    (testpath"test.yml").write <<~YAML
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
            - https:dl-cdn.alpinelinux.orgalpineedgemain
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
            uri: https:ftp.gnu.orggnuhellohello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconfconfigure
        - uses: autoconfmake
        - uses: autoconfmake-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}melange package-version #{testpath}test.yml")

    system bin"melange", "keygen"
    assert_path_exists testpath"melange.rsa"

    assert_match version.to_s, shell_output(bin"melange version 2>&1")
  end
end