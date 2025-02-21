class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.21.0.tar.gz"
  sha256 "6e01b885dee33a9c5db432f467c17a101b71a3a5c346241a3ac26c053331ee4b"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffe769731ff6e53b53d9b1bc9276d8558ef380ca9890138de6481aae6e819495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffe769731ff6e53b53d9b1bc9276d8558ef380ca9890138de6481aae6e819495"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffe769731ff6e53b53d9b1bc9276d8558ef380ca9890138de6481aae6e819495"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce3b4e678c4d4c898bc1cd4d6fda420d1eefce7ced076158cbaa142b590dc703"
    sha256 cellar: :any_skip_relocation, ventura:       "ce3b4e678c4d4c898bc1cd4d6fda420d1eefce7ced076158cbaa142b590dc703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7c29e059fb6f3cb6345964ad823846d6bdababdc2ef14a8bd3400a878b53b39"
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