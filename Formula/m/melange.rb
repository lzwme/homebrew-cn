class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.10.4.tar.gz"
  sha256 "98a3b7650b13587feb5df6ddf85773b348c12651cde0d0c256ffa738efea2d08"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "151d26f94329e27c50482a745808dec387e49a4f6238a8e594338b029024d733"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92a0fe66c0d810635c1df09e631daf1471c2a233835368c252b8ca2678f78e97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f0227175351465e781fc689d2be4821de558db42b7229b123bd062505eafa39"
    sha256 cellar: :any_skip_relocation, sonoma:         "99532e321e5536025d4c004e1750abf63b51431268545595f89b0db476b06e89"
    sha256 cellar: :any_skip_relocation, ventura:        "9b56e2c6e5723ee58d9dc54676a562f4c8a5d7e03e687ac803f0856a7c74a242"
    sha256 cellar: :any_skip_relocation, monterey:       "31b8ace03c200a248c85bec4ecb3868772b504cca20c8253057a92ea0b9a4c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0894d4a2e7588729278ae78ae02f6dc2d7d516c20dc0bd9c501a27089a7de779"
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
    (testpath"test.yml").write <<~EOS
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
    EOS

    assert_equal "hello-2.12-r0", shell_output("#{bin}melange package-version #{testpath}test.yml")

    system bin"melange", "keygen"
    assert_predicate testpath"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin"melange version 2>&1")
  end
end