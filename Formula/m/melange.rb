class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.26.6.tar.gz"
  sha256 "778710f6d618a98e70da107f1ef097139ac6fa6cd909d0c36ed74a2585b67c0c"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c03def72ac0f8a743604fc6c692aaec3300df30df404920ff979c131d73ddf6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6303c80231f3fa60db9c9315a14ca45ea25d6ade7420fd6ca5c1be96cd9ff648"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d03612ed7aaa86cdfc045d4fe6dd5f01992c7f6b921f9a73ff13ed3766dc2b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce5061b016b068d0d98a10a84c8814c9e68aeeae6b455c3735b590e7a9dd1a13"
    sha256 cellar: :any_skip_relocation, ventura:       "7555f1d56357ab02b9b54724237812e2f4ebbdce261305aeeda3a1a2dc13e790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b731c2225421e73e79aacd7668b5cb1e7b17dcf604bd72064e0b55a31e662217"
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
    (testpath"test.yml").write <<~YAML
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
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}melange package-version #{testpath}test.yml")

    system bin"melange", "keygen"
    assert_path_exists testpath"melange.rsa"

    assert_match version.to_s, shell_output(bin"melange version 2>&1")
  end
end