class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.6.5.tar.gz"
  sha256 "146e961212d1c7877bbc969e853e4f10b8605e6f851504f7d6ad8e1ba91f65d4"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9a365fc676451b5e123ddc0112297390acd5d5e5186052e14b8563a1f7864de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59a4e5e5831f83a24ca32814f4804da3db232d047b84f44886ea0ccca5db26b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6da1c27a180716dc2521b3f48f6cfb8ef2d982606859d6f26886761e23715b1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d627c23a55f06cde77a4f52cdf61bd59a169236140f84c81717d24831c1cfba0"
    sha256 cellar: :any_skip_relocation, ventura:        "e365d308257aff792e2107f8b3acb4ad18a6c382ee726e703a9d97f162b074ba"
    sha256 cellar: :any_skip_relocation, monterey:       "ca99e108a5c52284685176d41283ca658a854aa5ca295926d5bd0ed94397bfa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b492f0f0a4ab60296f795cedfc480f1b51a14d6e5303a7825bb2df22ecb6085"
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