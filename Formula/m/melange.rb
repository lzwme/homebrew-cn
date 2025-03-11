class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.22.2.tar.gz"
  sha256 "1453c824125fab5b1ab570b40f58a006d4637adddb279a865b3269aa5f5ab91f"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fde28e0484fb5196751587f518d6bacfd1fa851fc19d9fbc4a37dd1467d68872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec979815491265180b0f631fe6f69a7f0cb58efa847ded409e018b7f2da3fc0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a15c3cec41a389cba386c45df23477a08385b435f9f5afc0a0affe318f29444d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a058502dbf5aab72c91d2540027ae8d25e8ab601d3213bfac2066609155a9861"
    sha256 cellar: :any_skip_relocation, ventura:       "6c5c94335b52e9068665e6dc67b98ee9653574e59f05a11288facf4b1525e1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc200c990947e288861d0b47b4cb353fe354439c18db0ff5819c11ded92b3ed6"
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