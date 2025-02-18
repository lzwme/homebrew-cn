class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.20.1.tar.gz"
  sha256 "af7321070e3028eb10197342a7ecf973a36ff36069e8ba0b74e5fb9133f8cc9a"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "521df944fbc96e06249c0d4fc4cad9b614c7650b0b70ff8dd9e0c8f6375a9db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521df944fbc96e06249c0d4fc4cad9b614c7650b0b70ff8dd9e0c8f6375a9db8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "521df944fbc96e06249c0d4fc4cad9b614c7650b0b70ff8dd9e0c8f6375a9db8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b20487db922a388788ff50a5164e0234f8a1fcf96f8dad5c47cc132219bd25f"
    sha256 cellar: :any_skip_relocation, ventura:       "3b20487db922a388788ff50a5164e0234f8a1fcf96f8dad5c47cc132219bd25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807ecaf29f6ee85b55bc66b0925220f50f6be7ed2262387b04f0f0ecc2f7868c"
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