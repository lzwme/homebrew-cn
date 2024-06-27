class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.10.0.tar.gz"
  sha256 "c1ea39bcee7de125a98b8c4ed7a75196f57bc0f339c5f0feb9999950c5ededc3"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "187e6448e8ee2b0609490b7b4d13c56f72c47a42c4039dce05b1bc1fb4287fee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2a90f4fb977024c358a25bf823d908688cfa30cc206d6e3c9a40dee69a2406a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8bf78e22c12e4728acd12cbe10925a32daafc87bd871ba3ad36d1f653915524"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3158b7618daef5c3374ce614f66b359566b5a9b637d823e41b7df0d7a3f1776"
    sha256 cellar: :any_skip_relocation, ventura:        "7f6f9652bfedf9695874594dab9f7c84e180a0310bc7fa7e07d2a9559e3691e7"
    sha256 cellar: :any_skip_relocation, monterey:       "57ca739a00c5fbea2efd58811c73d899c5ef9e7f8403ddfa50834afdd9828a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a87b60eb4cf180932831bfd89290c5a9b77d39294212de5e25e0f0b45a8c4a5c"
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