class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.29.0.tar.gz"
  sha256 "5e976f5707ed7da3bae00fb726d96c1f6895cd944fb3b3f107de80e47b824bfe"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56aeaf0d01d51c9241d2ecfa83ea521074281700837fd6ea2103f40e433c014b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a55a84ca2de5fd4cbef69e555f52304472b4b0b8d2b406b3072995c1ed5dc17a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7d5fb97027161f450e939daca8c071fc8134af1c1cedcfed190d68d994363f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "164b3aa5fc654d83183f376f7e6cb82bc2e1cf3d11e7eb1efef5bbc8224f82d4"
    sha256 cellar: :any_skip_relocation, ventura:       "3096f2a6df3e0a218335c67a3d699ac460dd75d6af1fbc49232220d3abc43c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29392a45f7144a79ef345fad06de335c23777a1c7be6f6d47629b4e560437972"
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