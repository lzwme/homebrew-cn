class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.0.tar.gz"
  sha256 "b563934514552d86fed57879489f3ed3d534265d5839fcfb488bf4534001e10b"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9957fbf4838d0cb235fe54921d56836d949fa82d3a901afeca6952c1d8f956b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1e1cef4ca3f83d926e436404e0e88782c05f833b1aa8cde9c6ae7f1be680276"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b9e733968b3304f19b7e87e60518f3ee52c88822ca7cb5cd293c9d3ab98cd41"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3c9f36b7d16e495b5ce8a43ef64c758dfb424ca23d2c8456b55a51f444d8d5d"
    sha256 cellar: :any_skip_relocation, ventura:       "8d1d05aa19b0d8577a572aab02a3171ae487024c64a5627f9dff7554d497770c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dde91434b23312fe80cfb29c156093831a95e2d04182058daa5dda0186171d80"
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