class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.21.1.tar.gz"
  sha256 "c0fd9949dc1d674d048c860d60af6a1765d9dea2c88d05ac1bcd66cb6bf3ac23"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6580ca14be4ea159670bad59cd9eb5815e5102a007fcf0aa17b2d67e18be559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6580ca14be4ea159670bad59cd9eb5815e5102a007fcf0aa17b2d67e18be559"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6580ca14be4ea159670bad59cd9eb5815e5102a007fcf0aa17b2d67e18be559"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9c1b712e87426e250be2bb5235faf7a93581ddce975410ce78e4d87f9263855"
    sha256 cellar: :any_skip_relocation, ventura:       "e9c1b712e87426e250be2bb5235faf7a93581ddce975410ce78e4d87f9263855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d11ba4b43126e9da5c73d5dc1fe0216fc6c67ecdbfea81c3be6bb424d5878e0"
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