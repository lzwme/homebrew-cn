class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.7.0.tar.gz"
  sha256 "b70ee0cfabef9f12ba7ba54f54b6720c6cb4d86c29246a479db362a38de7fc93"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e241b6d9e6179bde6404d2ae4161f10453af88840047ea378a2a49417c69c6a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7b27cce3bd079f0f22ffe98d2f975684e34c4a8f982fb54f2acfbe1a342e7c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cd55c606487f9bc759a8ded8de3d3549622ea2cf3648ae1746d75446540b0f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d40b29487cf9f4832ead46fd109e6fdd4a9a338f6e540a73184495a6c53d8c5d"
    sha256 cellar: :any_skip_relocation, ventura:        "33c770bec692618f45420ea31271dd07dbf9140682775d28fe7f136953e6ed6a"
    sha256 cellar: :any_skip_relocation, monterey:       "7ffab7bb0cc03108f731df535712238d44ecf9a9c7733a598b632944d7c9565f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14bd8c8100e7dd77ed373326e2ecd01f37e4e6cea9fbcc23df258911eff80fce"
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