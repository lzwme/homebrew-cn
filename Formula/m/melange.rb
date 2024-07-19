class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.11.1.tar.gz"
  sha256 "f4f25ba32ecaa9209195d36bc13abc2340cdcd9853708533a5462ebcd59be274"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19a1c77a184662e2e9340c7376d96ccba86bb74617d08b2b3021d91e2302a40c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "916c3e47af8304cb5d241e23e57a10f79b7db3c22eb6c802ba4e1998c35d6f9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fcf626aea7ff68d6ffcd9c86e6f640d3d90d4f89c95b18ec18e0b4f5005b52e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0625cba950c6f9c46db79ab356b51e11db137645eb5030db9d25d3ae86c2134b"
    sha256 cellar: :any_skip_relocation, ventura:        "a95bff40756efc8a02e679445105c0bc929cdae07d20dc1bfcbe70dc4072cc93"
    sha256 cellar: :any_skip_relocation, monterey:       "173d711a36f46da4a4981949d04020a1a2427256981a937ebcbcd20dc4e322af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7beca7296ef6700f8996fa74470dbf462b6f5e5df0506afb0aa5ba8878500a4f"
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