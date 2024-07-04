class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.10.1.tar.gz"
  sha256 "36aecbb93b8eac28bd6c920d6b844a084adba5e1f38e18efa458f4a8ab6a61d3"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f8b978731cbdc6a2e79f52a1a5cbd38e5f2947680650b0f7e98640a0db08dc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d789fecbfee4e397cc74664c103ca48ad549b040db484502021c86276241cdb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5083997e117be4d49ad12bec20b758d685577448b0d9115fde7b010f6d8729c"
    sha256 cellar: :any_skip_relocation, sonoma:         "67fec7b5eacb6b421b089fcc70910941cdc8eba8706d49d9b6d36c22a66ad416"
    sha256 cellar: :any_skip_relocation, ventura:        "bd824670f885d6052a6bd521e04d64a55ea2be5c42e5cf4bee2bf787e3eda2e5"
    sha256 cellar: :any_skip_relocation, monterey:       "f63f394c11db316215da0af4e71504d896b80f58e104930bd3c20aff23103655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50583199a05765c21dab5b6897e166dbe10f3817c70caa09c252a991e798d289"
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