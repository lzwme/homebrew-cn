class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.6.3.tar.gz"
  sha256 "42e970ec54f0dec3f7c93e8b5f1623925c54a63a10453b8cee57ee6d7601f958"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1842404ae52b2aacf402eb13f30bb6ed56e6f39ba2ecaf0396b32010d89904c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a16031a2fc74368bacd1af517a2531bdee27e33bb67c560147d831d4c6c6400"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b1d20da043efdee12936101149a86b7c632a608f43a879de2207b19c4d2055b"
    sha256 cellar: :any_skip_relocation, sonoma:         "66e05126368d2e078228d7e886d9501fa17025e82b5b90b0dd29393e44939eeb"
    sha256 cellar: :any_skip_relocation, ventura:        "22f74d6028558bf306bcc7a772be7193494daab857f2d7515a0c3078fabfb6f4"
    sha256 cellar: :any_skip_relocation, monterey:       "26bac5662d24475c8b04eb67e9a7b54a5387ebd67bf84d4e58963cfe70556d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd4228991d1e511b32216f6a4c7d47f38ed95497d2960de27759e462a38b7715"
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