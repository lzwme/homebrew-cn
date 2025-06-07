class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.26.7.tar.gz"
  sha256 "019a2aba32c5b475b2f5a24b0eea0693e78d943eed4ccb2702c6b96454a7d8a9"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de1816fa9352b568bba486198cedf80ce28dcec53391883103892418ced052a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d22ac3484f8d934f73d65f25b7dd39bd23c3db7f702f045c2b0789885e23bbd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50f6e0813b09e7bcacc3c2b417494a5357d417a52b0aa68586274ffe7f7e43a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3552b63c896890c35277207a87f045652a837a15f862b67f3a0bcc7b85e5a15f"
    sha256 cellar: :any_skip_relocation, ventura:       "d7913bfd4658fc2ed1c87b96a373569e449da83dc72acab6ec52898d1ceeb890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd31a96f614ab919df05bc7aeced4db6563e6a7d3d3efefcc90e19627e3e0ab"
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