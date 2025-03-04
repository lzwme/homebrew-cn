class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.22.1.tar.gz"
  sha256 "5493ad4a8a20d18d09471ecadfa4b518d91592c86869c33a64181609a554e236"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb7ba8afb60504bfd53dd50daf250936dcace8cd1b68fd78b9f0252c49961885"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "946e9193ba9f150419ee751ae4960f766c63eb1c7dd5f4415e423dd6c4c495bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70a30dc34582d8a756abe520011396007d7d6bb773e0c3c0cae50a185409058f"
    sha256 cellar: :any_skip_relocation, sonoma:        "69e8a82862151c28c463319ce85935f75eeb28879e0acf7aaec9f066436f5ee3"
    sha256 cellar: :any_skip_relocation, ventura:       "003638004814262e142389883dce969300b3f5348d0ce2382a0833dc4e7e1ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31f5adeb266fd51a4267c0cda8a470f810201bb3a3bef01c4e76a84f2e323577"
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