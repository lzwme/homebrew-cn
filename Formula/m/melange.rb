class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.8.1.tar.gz"
  sha256 "16011cfb92fc50b019a3b897d6c64aeff7a87fc824ed3a23a7e1a888eb0a758d"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27baa91666a8713801e8461d8460c5e8b17fb7c15be1dc7c15069188de7fd278"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b256ac7b66b16151bedaa908a5f41c19cb4937c59ea027f94417dbc43bc042e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8016c692b67db02c3ccbd5fa895323a2f6009866059cb29a9e9f98800ff09d4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "499d396841100dd2b71c18a44720944189177d7a750e62a8c302d630d094ec6c"
    sha256 cellar: :any_skip_relocation, ventura:        "01ec715f98e6e6c207286040ed7b3e9cff6cefe205a9fbee24c8d84fe549b5c4"
    sha256 cellar: :any_skip_relocation, monterey:       "298c361f4961ab1bfd8206dcb360d5ef973b24f0e7048e900535e40a52880a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab42535538cee8c396d9f87b326e9f42b00c63f6929754a72fd24e75a5b2c616"
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