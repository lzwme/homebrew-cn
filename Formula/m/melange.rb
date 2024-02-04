class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.5.7.tar.gz"
  sha256 "7db958a2cfaed859e1a88801eec9a0aed4be71f47b5630317494426dfe7599fb"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77701e25317ee9826a3416558156f251d99850a2ce938ac9a542a724368fc12b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfa2c2fd8ec402ac5f68d366b2a3971b0d84b96fb68001e93f099a6b3e5da31a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f175244ecb4b916f4a25a5b48a254e3ad66131705abe272220236e4e18fec33"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b222e50a25af95fbcfc91061174c1cccb968a090ec5707dac8dd43b2b18d307"
    sha256 cellar: :any_skip_relocation, ventura:        "1ff3e4e59a3da8e9ac2afd221dbb967d351fb7ac7c43e8377705a17b2f5b412f"
    sha256 cellar: :any_skip_relocation, monterey:       "6c14947273283a8f3649b86a45ffec7386225150a181f7f8849490d8be9c1f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9d7f4ae3c5d92d21fc9f6af9b7cd0d2769b87f8c272404ef9d5eabfddf8f6bc"
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