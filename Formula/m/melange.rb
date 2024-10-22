class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.14.2.tar.gz"
  sha256 "92c60fc4d59ec3e971fffe2e0f2a8b9236f5b42e21f9dd18890be1f0e350ab39"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ec59ea3967d7b8389916f48f7dd73ea1f6df45f86f31ed4830990a38eea50ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ec59ea3967d7b8389916f48f7dd73ea1f6df45f86f31ed4830990a38eea50ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ec59ea3967d7b8389916f48f7dd73ea1f6df45f86f31ed4830990a38eea50ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba293fdb5cc12e933afae279ea994ede4b590a23207d0bf3e4b2d9364f2a5212"
    sha256 cellar: :any_skip_relocation, ventura:       "ba293fdb5cc12e933afae279ea994ede4b590a23207d0bf3e4b2d9364f2a5212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1b68dd19b2c791f3f2c47d4c9c2e24b8efdc23c9c0126a519ead7c912a523f"
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