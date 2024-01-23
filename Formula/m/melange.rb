class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.5.6.tar.gz"
  sha256 "a870187b097956a2522764f7b639fc4faf19c50c12649a2467e7a800c9d1542a"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14ee51a44dff1bca10fbbdb97b10a9a11a0081a3fc91e1938787a19984cd73c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "129fe0d16af8fca9c0b1e9fa1fbe7949bf147f762262d9ff64a6ffe62c791fab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa1fdb950f6a11f3bea19be4f8d970da4bbb07fe6cf29f04c26aadaa2b96bfae"
    sha256 cellar: :any_skip_relocation, sonoma:         "b690ff617479d049842f3c808f9705ec73085e82efb72be6cbc3e359cdcc2589"
    sha256 cellar: :any_skip_relocation, ventura:        "766c5e9f1f3d2d0d9aec61daf54b2972746af791388cfcf76ed4b072893a27fc"
    sha256 cellar: :any_skip_relocation, monterey:       "6f51a1ce20a2cee581d21358aaebfa168b518fc9b77efffade4a1c1b804ef678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2273a7a91026f534e7d9c86194faf9ca68d91e42ca3c642db446453aa0c54d5"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

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