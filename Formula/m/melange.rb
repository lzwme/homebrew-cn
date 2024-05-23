class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.8.0.tar.gz"
  sha256 "6026ea5d8a27cc35905928b9799252d9114107d276e68ceba7ac4f2e4d54e9e6"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb32cb8a05b8a38a059f295ba877197e35d6977f8fc383e0f33e5b25bd4e7e98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcc3011a19f3f093d66dab456205b8d46d5c46b3f9c3085fd25bcfc00870d3cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cec59c9976e1f46c4f511d01e75772344b95ad971eb724ac251988ef2d44975e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd83db3f45171a798dbf93838bb7e281498f97806d7dee008caaf9e36ebdf374"
    sha256 cellar: :any_skip_relocation, ventura:        "6aa5be6e5bf78c0c2660064d5a7fbb798f44139b1e06d163380a2c5adff9e559"
    sha256 cellar: :any_skip_relocation, monterey:       "2ecb57900eda5c3cb83de2d95aaefa7e80de16930a8154f2d7d36996dcc8e0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d4804d782b81d620543d08bbd3320a9242046e8e8fbea81fcc92c77df8a8b97"
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