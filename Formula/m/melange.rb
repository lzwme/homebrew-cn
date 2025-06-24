class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.26.13.tar.gz"
  sha256 "5da01b719c51613fc75821dc8edbb6509faa6145dfa5f8145879224f0b044466"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11068b74303f2a0224712630e0637cb25358b9bf530e2775f894c279f1639e95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0996a2fcc4e7336527a9fabf3ad671301131dfc286a28cffd9a2fca6c3686a0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "612daa94188ea3253f38215e42d59d3cff5152da2be6a60f51bde6290fefb24e"
    sha256 cellar: :any_skip_relocation, sonoma:        "67f9503caa026320e1c07c25841b2effb39fba08487b64c65f550386f9cdcdd9"
    sha256 cellar: :any_skip_relocation, ventura:       "74f75410d0f007089bcbea3f461695e6c0844ef158569452e5a4c8192f71523c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71cd8b25d40af1ab280f816fe899bc035361d26704e717688562361e1659562"
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