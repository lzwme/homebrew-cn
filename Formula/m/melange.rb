class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.18.1.tar.gz"
  sha256 "84ee28bf66bf3fe47d7b533c16c9021ce2b55bdbb05781350673ae701adb081a"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80284abf7547f10b8e6a785ae1c2134729249fe8ed2ac3cf2847583dda5e277e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80284abf7547f10b8e6a785ae1c2134729249fe8ed2ac3cf2847583dda5e277e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80284abf7547f10b8e6a785ae1c2134729249fe8ed2ac3cf2847583dda5e277e"
    sha256 cellar: :any_skip_relocation, sonoma:        "56e8b34fdede74047f8e2d5ee65f29d2fe5424d6642070da3e980f4fdc83abe1"
    sha256 cellar: :any_skip_relocation, ventura:       "56e8b34fdede74047f8e2d5ee65f29d2fe5424d6642070da3e980f4fdc83abe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "360d69093a033c928d39e04ee0edb1dae99bc009e2c6df1bf3c8473e6e3e7796"
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
    assert_predicate testpath"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin"melange version 2>&1")
  end
end