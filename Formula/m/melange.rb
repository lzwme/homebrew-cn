class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.15.5.tar.gz"
  sha256 "90db1bd9f5cc0c1f089d2ea0289e1d8bbbdb620c928f762db4c665e1e156c390"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348ffded47873c3122984a039979eb3b7fc5ebd6b08dbfb47864f9b83a5dd51e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "348ffded47873c3122984a039979eb3b7fc5ebd6b08dbfb47864f9b83a5dd51e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "348ffded47873c3122984a039979eb3b7fc5ebd6b08dbfb47864f9b83a5dd51e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7823b4140ffd715b4f8afd585082319b22f11d3fb35925254909f3e2ec967c6d"
    sha256 cellar: :any_skip_relocation, ventura:       "7823b4140ffd715b4f8afd585082319b22f11d3fb35925254909f3e2ec967c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e17fc5191b48817e3e54e3318ee03b8ffb677a1f33f5d7fa584eee42bd8cc9e9"
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