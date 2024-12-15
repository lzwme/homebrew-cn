class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.18.0.tar.gz"
  sha256 "db253bcb67db91b580d32bc7088b06d12d1f9956a3cb09737a8afdcad731883e"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ed7be465964e0361dc6a61c99666bee1a821b0c8b62844adf6e23caf7cc91d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75ed7be465964e0361dc6a61c99666bee1a821b0c8b62844adf6e23caf7cc91d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75ed7be465964e0361dc6a61c99666bee1a821b0c8b62844adf6e23caf7cc91d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfe036ad3a88b12c4da78bbb68dc72d326f446f0e345d1b574734f6e8233853a"
    sha256 cellar: :any_skip_relocation, ventura:       "cfe036ad3a88b12c4da78bbb68dc72d326f446f0e345d1b574734f6e8233853a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd11c8dfa6c1d714da67bd79eb4809d6d84c8bffb374e6c50bab3a5c9ad5cc25"
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