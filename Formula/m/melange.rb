class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.24.0.tar.gz"
  sha256 "b1e90f2d90ddf1c1e83f0ac6096e317e46805adf513bdfa48f62b79ef437c539"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "673d0096592665ee9a81f1e23b663ed3a9c11b5c86d52388d0923f4014260e15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7193723e019f909885528dd0fd5b4133723488f3d185db5c43b61447bde79681"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4503730af611a59a27e0e0bc9133ff5a8aefa471c53a60d5ef2b1bb146eaba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eb09a9a306083a3483d3b3347abb77d7daed89cb376a8e71e3699278df9782f"
    sha256 cellar: :any_skip_relocation, ventura:       "d048d7e294a3a37fa576f61872005d4cef38b9502875e67d53d90b84f8aafc73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ba4b36f2246a47ebb2bbf2fe5e87a5fed3c58ba8a825753ce1ef1bd23d3556e"
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