class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.12.1.tar.gz"
  sha256 "6f32b6ad5a88f92995052739b46dd09b3c796b818d8d8ff9549be09882804e36"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c8ec150f802dddb6b65672e7bb42a214eb0ddafba17000d699428f03520b7d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c8ec150f802dddb6b65672e7bb42a214eb0ddafba17000d699428f03520b7d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c8ec150f802dddb6b65672e7bb42a214eb0ddafba17000d699428f03520b7d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cacbbb6fecf5f37a76917b8c92d6481cc693c3a1566450920ae53a4a247d12e7"
    sha256 cellar: :any_skip_relocation, ventura:       "cacbbb6fecf5f37a76917b8c92d6481cc693c3a1566450920ae53a4a247d12e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae3dc30cd4cb89b0df491313a3adc3cba35c59f676b615a6cab45c7fa5bb48f8"
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