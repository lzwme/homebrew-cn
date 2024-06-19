class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.9.0.tar.gz"
  sha256 "678027c46bf6da0ba2bb52884dc006db20796196eb75517ce55ba7d2c0192363"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac0d9bc731269d14573c097a67b667dbb9aeed0c8b3adfd825a3af0a688c2b95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3be1db06e635ca65cc11eb93bfd6a29070c5e5e6c559cbe03e00732a74d5bc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9721731b0449b53e40ecf934d6b2daedb4eb0e014783b3617691fabc60ccc3e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "e148fab9ae5b24f53a2d4b1a1afdb180151078cbe3a648d3f7efcb5a24087148"
    sha256 cellar: :any_skip_relocation, ventura:        "72889f5a0ef71a75e0bebeaf4ca08de8d68e336f717581ca73426703f243a2be"
    sha256 cellar: :any_skip_relocation, monterey:       "e3d8dcec576490e6beb6631e7f001fb3811495aa3d8835d52b7ca518a57529c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d8b2374338242a704362c0d859685b286b4d0d1107e5ebe915ff05691c50591"
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