class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.17.4.tar.gz"
  sha256 "52a7c58d535e89570203cd54d1df38cd8c0a76920c955d63fd2fda5bdfa293ba"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca76f8c6e46ab136d6f868852491a655bf0286fde52a5b2036a92068e4f48c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aca76f8c6e46ab136d6f868852491a655bf0286fde52a5b2036a92068e4f48c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aca76f8c6e46ab136d6f868852491a655bf0286fde52a5b2036a92068e4f48c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd3bd855a9f30fbe6776ed1f3b9277cc22cc59107cf8e19312295c33b2e40624"
    sha256 cellar: :any_skip_relocation, ventura:       "dd3bd855a9f30fbe6776ed1f3b9277cc22cc59107cf8e19312295c33b2e40624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe5a35318871d440f7797161e40003e50e422e33f1e923f3a33d0d945d45df0"
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