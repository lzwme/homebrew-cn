class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.5.9.tar.gz"
  sha256 "0b0d7b773899c98fde7b5c6ad4e298d3b0536b3aa94bd519e88f51b4dbfbf220"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac15036b1a902193c757eb0faa7d0ce1e1e93f7871b37e565f69d4fb7de957d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15d139196ea79617babd0edc81ab7254daebeac915a8cf3643e05e4cbe3b82b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a89d43b068ea5823491b1c45f663834bfaf1703c6f25da4fa7f01f713f0bb28"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dedb570918a55e11393923914b2296f0d65aed0a1fe0475dbc48718791c67f5"
    sha256 cellar: :any_skip_relocation, ventura:        "18194c77ab87b4170157d92112bb242ceeb6a8bd3d2d99d28e07641fc28d864d"
    sha256 cellar: :any_skip_relocation, monterey:       "cc146b36831526481c53538e851a672373d8b39827eedc2e1efc7f3041f38992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de6b2e596c87211cd2d6ca122616e62075f3203278e6216d64d0998fd241e0c4"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

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