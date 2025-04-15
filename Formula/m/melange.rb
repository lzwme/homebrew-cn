class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.6.tar.gz"
  sha256 "395e86565080c3075e33a2bd158d2522a0aaad1762cf7e8e94769570d9bdf741"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e56806e41b1cf577acf141f8e92505de27dbe3c9b125d5fd46b7ee03fe1da287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e2ab23bf90dc512c2fad57a46191c7cd71c1e96cdd7b90c1443c00bd3a55b12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12dcbff5e252b987f977a5bad0aaa2ec82b940f4663fec2dbbb30d8e4976c77c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f622d9072c34fa3daee41d294a0af2ee1752e37fa603b10d70cbc0c5e0d86081"
    sha256 cellar: :any_skip_relocation, ventura:       "e67dd667b05799e932165552466d75abd09bd51eccebed1820ee388f60db3484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c2a7f99a3c8bdd819d5127b2058bd9f5d72fedb98eedfdfe60f13beac260b64"
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