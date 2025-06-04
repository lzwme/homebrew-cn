class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.26.5.tar.gz"
  sha256 "ebaf53f66596c4bf409c82b7b52aded0b0ddf79d7923f5d25f9d2fca3aaddfe6"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e015462ec64a97f5efd015fca9e7b0c87d00b44f1ac3fe03b4829951b01088b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b1d487e950355967a51d91617bd938142607ae8f2033032934d0ee7b4f8b76b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38149e79250adb3fe580db29791201ec7b0f7eb09bcaa056cbeac3169330f6f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c14587832a57ebdc3f4ee40fda963feae2b28b87543683ee313dc7cb0898a61"
    sha256 cellar: :any_skip_relocation, ventura:       "0bdbc579ce6ebbdf37a0ad06d65760711ab661de305933b84e537e76bddbfb37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ae3b631197caa092b5620c55f2338274913f7b874d9a97d79979af6d01e1074"
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