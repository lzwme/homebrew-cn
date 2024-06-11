class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.8.6.tar.gz"
  sha256 "e4222e5ed01136d0df3be021771ea0773d18ed8748002d812ee995ec2201c695"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8454a6021ec25011796f3b0bb95d03b25b76d6bd9608872c03172235eeed43d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43eaaab6de59cec7f4592b70a173082ce7a8d62dda0e8d283a91a8b1f51b1005"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32790a6eef828c88a1c1012f0451c3e0bac555bf7d762d72f3c70c7e37aaad7"
    sha256 cellar: :any_skip_relocation, sonoma:         "28585223c7781625ad2e64b9ea5cadb32f9fb6c244a37b8ab3352a03c14e6fdc"
    sha256 cellar: :any_skip_relocation, ventura:        "b1304e6983b2ecd70481aa3bfebcb4198e342a7f1e34fb5003cbefc504650ddf"
    sha256 cellar: :any_skip_relocation, monterey:       "948140b3b6af107d1bcf24eb4d9b61e4fa85d214a46d11e23fcb3070b6d7a2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67ba3708d3eecac6464b77c7fca6658803f9c3983315588b2f33840b8e616d5b"
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