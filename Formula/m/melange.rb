class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.11.6.tar.gz"
  sha256 "1a594b8bd03897337370976c30881e099ddf0490d7e959e3c729a3cbb9329a72"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "960746572da6b8b9448e85632cbc14074a9a3079efd6db3cacf61691de4dc2e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "960746572da6b8b9448e85632cbc14074a9a3079efd6db3cacf61691de4dc2e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "960746572da6b8b9448e85632cbc14074a9a3079efd6db3cacf61691de4dc2e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dbe02e060c5288b5efcfd2927cae540be76a787c4293b07780ac369c9bca150"
    sha256 cellar: :any_skip_relocation, ventura:        "4dbe02e060c5288b5efcfd2927cae540be76a787c4293b07780ac369c9bca150"
    sha256 cellar: :any_skip_relocation, monterey:       "4dbe02e060c5288b5efcfd2927cae540be76a787c4293b07780ac369c9bca150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8463d0e254ff899ee98819812cd855044f9ded31f44717d36a0488f7ff26aae2"
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