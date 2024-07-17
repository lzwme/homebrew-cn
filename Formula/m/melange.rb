class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.11.0.tar.gz"
  sha256 "c14d9af80bf129ded00fa34f2673e1953c28f2c66e6f76a8098db2ebc1dbf3d9"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61fd3a595c64283ae84564ac17ef299e53002500ceee0ecb6c610ceb467ae3c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2028ccb91dcb94a3e962ae56a7523d6b8d396e95c982b51f3346e5429c14a305"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c090db73f89bef7293afa0d51db225a32b79c5d23c6502079a02be0dd790ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1defdf83d34063def3d20a9626389dd66d0ca85571f4a6e2c670ba6da90d7fd"
    sha256 cellar: :any_skip_relocation, ventura:        "891b6f834449a96c05445b4b3a7680437d5ce9aa891946cb7abf2682e0a56274"
    sha256 cellar: :any_skip_relocation, monterey:       "8e7e2faf73c3d0859d3d979ee7026d48960d62ab806ae18584aa90562a8215b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c402fd4e50c7eee5545b3556ceff6f377b949c9287e70950849eea2b677e7c7b"
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
    (testpath"test.yml").write <<~EOS
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
    EOS

    assert_equal "hello-2.12-r0", shell_output("#{bin}melange package-version #{testpath}test.yml")

    system bin"melange", "keygen"
    assert_predicate testpath"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin"melange version 2>&1")
  end
end