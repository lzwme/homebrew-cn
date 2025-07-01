class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.28.0.tar.gz"
  sha256 "2414e9016c457ffa12f1e06dd9323bd3965a37084b49ec6fa3411c4b74ceac7b"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec9b0f9998d0b3c2622defec894697edb6584a19702bba935c588a4963280345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a90faa166284535a08b6ce49345385dfc31f2b504ef8681d8e8c61c7936de4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baedd01bba9d00e48f9833990049105e9d73ca9a3a88f1294192e046a52d5bb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f362e744bced122f631817bdb5127ad67431643782acba3888b931ff3ec54a5"
    sha256 cellar: :any_skip_relocation, ventura:       "764c0dae4b85d1f25b9877b5a9613b5ef1654c939625f3cdecba766fff64efec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b797014ff44c1657a41f0d7a864f0c9502dd3e395eb6c5fcbbf0d411da7568f"
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