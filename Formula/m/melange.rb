class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.5.4.tar.gz"
  sha256 "2a102223eb46bcd2b267c3fafaa49fd0af43b891b4a47733a9295b7a9609cfdb"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9952fcac426528bf0befe1e07fab1e1da38e470627bf80a377b23fe30cceb06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eceb48debff196019c30f2d8a2f329db1cf4792e2082a7a790bc5f92c0628be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49553bcaff1295778ed75689bbaff3dcd03bfa8be8a8b06003d190a7950d628f"
    sha256 cellar: :any_skip_relocation, sonoma:         "67021aa52ac6f828d896ac82eba9cd7e73c9b01790e0eed791c5da045008df5b"
    sha256 cellar: :any_skip_relocation, ventura:        "24b1125f6f7317c1dfda5eab7dad9b0c12cb16b9e0b42b513fe9d12149654ea3"
    sha256 cellar: :any_skip_relocation, monterey:       "030eff1201d2d2b3ffadff060164184d41ce6f90ad4680a24dc25f45e3611b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a696e0a42d8cd511fbe8003647d3a2c284e05fc95ba4a4ba0390e7e26d810ec6"
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