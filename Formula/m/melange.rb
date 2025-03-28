class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.2.tar.gz"
  sha256 "fa7d616277db177fe688cca1307cc2b5b21196ae5509435f52849bd310dfda72"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9ff45235b072482aea1ddf20490d0ee3d230565ec433f6300574f1d883d38db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fec4f2e5bf631aed944176cd1b4ecc31107c135efa663ba77ef5bf8f24e50c3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d4783afd4b84cd719c8341c35298bdcd6fdc002b2f093900d9b93359b1dd910"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba0a4f7776af42394a1f33e5f7f964035badff54171ede631c321f66672d11e2"
    sha256 cellar: :any_skip_relocation, ventura:       "80e8a87ed88a12030bc0d1e68331f3f8a4f413b45fd119a580f3ed58ba8fceb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d7ce68bd0a1b7bd59bdd842d8fd5ca3c865ba32814ab59e679b1fc88c3f169"
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