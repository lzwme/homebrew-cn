class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.25.1.tar.gz"
  sha256 "83c5fc92464a3b82f4c90a16e34fb18150ab1815a5923be115e2dc3067d0ed77"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "307a93301405fe1de342b34c5b55b4bea235cf72a302a6d5bd5d0267b50eab6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be06c039be036e4d920cddcde7db2e89ee4cf41f8d10f0315ef98676f3e3f3df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "554bc98fadab640d5f9a9c098e15e5f3052ba93f49fa7e99abf4ce9bfae192ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "d38f771abddd3795d83fd10a591f62bfc8d927bbfffa697b52c81aa8fbeac7ce"
    sha256 cellar: :any_skip_relocation, ventura:       "538698a93289b8480d2d86a539fa7ead2c61a91f518164bd45412d178347dce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "589d280b0639cc1bfbb1815ac81307c6aefb6c06672a35d451e34647202ad5d8"
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