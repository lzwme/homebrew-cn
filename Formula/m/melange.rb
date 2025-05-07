class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.15.tar.gz"
  sha256 "985f24585ebd41734b8fe80e7a22aaee58bd9db0df893b4878b6a54499bf4ac2"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3f51c4acf688c7c4c27c23696bb186bb7c01789ce8c2e227a22cc16d061427a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603154b31a9382ea5c6556e349b57e70a580d08a822ddfc18cde0285f07c2a73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87347e9b26eab8db46c06805f8c8d3fb205f8531d742e467dd7c1a1b09f8115f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5fd385d08f23c4374387bf372caac6ffd097a2de364cf7d950e67b39e0aa1bc"
    sha256 cellar: :any_skip_relocation, ventura:       "0c8605744c670048172ff0ea8f5d777242bcbb2109c149f361bf969b9ef75027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b958632a5a30561498c40fc2001cb5f4451c4b5e52816c43bd4b9d1580f9dca1"
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