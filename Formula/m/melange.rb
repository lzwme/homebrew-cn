class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.13.4.tar.gz"
  sha256 "c7ecda2a8f3ef9d956e9a3efea4c12080e2a1c73ef485c85a88cc310ce4b8ada"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "216fbe6ce9ef29f39b888b74cffc28388b1ac227dcb2dae1238ee55c096b9af6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "216fbe6ce9ef29f39b888b74cffc28388b1ac227dcb2dae1238ee55c096b9af6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "216fbe6ce9ef29f39b888b74cffc28388b1ac227dcb2dae1238ee55c096b9af6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef87785e3b70fa45b039a20404ca3eb0a7e34837cc4bfc67ad1c6fad473cc36c"
    sha256 cellar: :any_skip_relocation, ventura:       "ef87785e3b70fa45b039a20404ca3eb0a7e34837cc4bfc67ad1c6fad473cc36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7836dd3edac96cdc13c61aef80127d94476f6e18317aabbe280592f960974bc7"
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