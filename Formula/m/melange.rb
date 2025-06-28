class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.27.0.tar.gz"
  sha256 "f75866b7219b5ae9351e36e1c25cf7d31328dbcbd9a0f255da4aec6672c570c6"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d717c5a869b27ba242adb7980f003f4bf5303e09ef965cb6e9e62f89213510ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5121aacabf14ec372ff3ed7ca7439e0d28c02928115910d39532fceb5d7344ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3bcbdebc0e53935d5d2eedce6af7eae47c12c39337efefa2772f368c3540f70"
    sha256 cellar: :any_skip_relocation, sonoma:        "98908a9a2b27f47f67e00a1249f2ea31e180584d0a5dbece111d985fa29a3986"
    sha256 cellar: :any_skip_relocation, ventura:       "9f342f218a2f9cd115cf732a9fba114817a554393a7fd61ce7bf023d1890b77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a399e081fcb731a125cde8328723def8dfa072dc442c9c0d85d2d462c56e3270"
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