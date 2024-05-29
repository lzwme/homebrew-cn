class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.8.3.tar.gz"
  sha256 "043aaf42b9bdcfe8f052cb8f73a4839a803f9b7e89619cdb950dc69e6237f9a3"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3d9af825beaae0e1bcac538fbbfef0b63a6fbfd878d8a1a473e891d21712d5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ba619a0dc8e548b3f8d66e8f6371e0db5735ba4dde15e138c3c7e2fd6408bd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8417e98401d3a2fb68625c62c16fc6ffe133a0a53d4768d9f067bf1b2a96ac9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fafe1d38187450477205974401be1fc5d4f32907d7cf54df33110442b8fc610"
    sha256 cellar: :any_skip_relocation, ventura:        "f41542c616c55aea0fe20ced68750f33ba2de0d06198f3e6ad2bbc384d448c38"
    sha256 cellar: :any_skip_relocation, monterey:       "a9fbe169e48972c99e4b015d437c073aff9cae3d3abf57a905bf9e15e6f31427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b946607851cdce9356630857b0d6043157c837e89a8f5d0e3fed91205d3d33d"
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