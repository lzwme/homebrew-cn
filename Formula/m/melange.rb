class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.16.0.tar.gz"
  sha256 "990309ac233351cf520f011d9b27caac7feccd871c7c79dac49b86ad3deefdde"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6fae588ed1ee56407d8634a21f2594b4276ae8d1d9e4cc54f434a4c08c55770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6fae588ed1ee56407d8634a21f2594b4276ae8d1d9e4cc54f434a4c08c55770"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6fae588ed1ee56407d8634a21f2594b4276ae8d1d9e4cc54f434a4c08c55770"
    sha256 cellar: :any_skip_relocation, sonoma:        "72402966312aaa3899fbee6041b20fb824c0ec7cc8922b2cf9e6d5fb76e59594"
    sha256 cellar: :any_skip_relocation, ventura:       "72402966312aaa3899fbee6041b20fb824c0ec7cc8922b2cf9e6d5fb76e59594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a878e98a1d7e9eb0d70ddd6fbc0192c4736ba5dcf0ea04d9128549fe1f6c440c"
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