class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.14.7.tar.gz"
  sha256 "a761d60b83d2a83d0bfedba94d8472ffa5b130600c7cf54eeea4f96b53f1e28b"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ae14366bda1f5bff1f5de4d447d577d36b3d7f62d607a1f144be1a373bb64d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ae14366bda1f5bff1f5de4d447d577d36b3d7f62d607a1f144be1a373bb64d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ae14366bda1f5bff1f5de4d447d577d36b3d7f62d607a1f144be1a373bb64d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf45bb920a3742c9eac9063d291e2e729439d64b906218dda0873c7fb71ed040"
    sha256 cellar: :any_skip_relocation, ventura:       "bf45bb920a3742c9eac9063d291e2e729439d64b906218dda0873c7fb71ed040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d36844f4e18a25648dfb693228c57f6799fd0aba9654c6c22ee3daaba14f9c"
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