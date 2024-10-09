class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.13.3.tar.gz"
  sha256 "727140d3497a5966e65c7b016a4d73a2504a76bb48b107e2de6197bd7d0f71ca"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8112a7c220f1ac11a11d36a55ba159ea49cf72812d5f186af74317c541078a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8112a7c220f1ac11a11d36a55ba159ea49cf72812d5f186af74317c541078a80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8112a7c220f1ac11a11d36a55ba159ea49cf72812d5f186af74317c541078a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "180eab10002c8bffc76fd29a633138532dac0cd61ebb4f3cf635bd75161e4c04"
    sha256 cellar: :any_skip_relocation, ventura:       "180eab10002c8bffc76fd29a633138532dac0cd61ebb4f3cf635bd75161e4c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b929b0ca9224f7dc9f721b47f8ddf4280dca42235244fb69a703f8604eabf7"
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