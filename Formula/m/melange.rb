class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.7.tar.gz"
  sha256 "9a37f3bc1e29821ac915436765cc12ed67b10185f7e83760c42befbf2c56d848"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59a65289ab7d268543d9d2acedc5fd0e58b27255122d975c76924f6397e4cf62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "322feb0963abb6684c6bb8404ab664be74f2bb9b84d4e6ab5b0ce24573205aab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7af8a343f4e15eb82ffdca825f1f6ac83fd9809bc36c8f24049e66a0c8c3eb34"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaec4c2b8f9f6e5a69520477911111cabb0fcf33d5e6865264d4449bff635b20"
    sha256 cellar: :any_skip_relocation, ventura:       "4aa70129b1e70ff2ab7dc6ee709cd68748afe8abb9ca5c6a03b5be474c047851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b35361b820a48a2f34c4fd30c837626dbe6da4010ec8fa65a04401a9f5458261"
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