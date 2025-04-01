class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.3.tar.gz"
  sha256 "9d3a228fd22b396fd6a70f63c089399ce5f44eec8ac404fc2f2f984753fd4e19"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9626bafe7b6a21a0d7147ceb8326c99acdb6495a527a1104219ec2ec8b9e8650"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "000f48f6ec153f5250c54bb552cb2acdede2197da25a44a9ed28a46eb0206f90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14e2610f6ddd053667acdcbbb9fb0176d74f613cdd014a4114b08b8770116683"
    sha256 cellar: :any_skip_relocation, sonoma:        "769cccf38ffc2a39ed5c5f678ecc52be2cfad6bdfc38a1b2e7bef3a649db6cc2"
    sha256 cellar: :any_skip_relocation, ventura:       "3f34101c473b7aa898364463522bdb252202ef72a14be73ebec782955346a01b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9fa3ad85be3cbc34443aa1037af9bf545b5be71e4d477e1673fba208820c43"
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