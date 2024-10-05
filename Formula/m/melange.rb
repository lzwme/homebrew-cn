class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.13.0.tar.gz"
  sha256 "5be0efe27297a5dfac3aa05b16ce7c694a80048c690ff0994826f8a14568c02f"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db07f6de711a80184cb46c31a0ffd9bc4071aea5131415623172e16a29545702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db07f6de711a80184cb46c31a0ffd9bc4071aea5131415623172e16a29545702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db07f6de711a80184cb46c31a0ffd9bc4071aea5131415623172e16a29545702"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f09ccb5bc328903aa58a23473e4de06be3d076ccf7d014cfff83de3068cc6af"
    sha256 cellar: :any_skip_relocation, ventura:       "6f09ccb5bc328903aa58a23473e4de06be3d076ccf7d014cfff83de3068cc6af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ff8cc1d044a6730ca8898b4a7c87d3f921c17f5c047f8ce8ff0b4bfb3fa535"
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