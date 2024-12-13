class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.17.7.tar.gz"
  sha256 "7820789732b4698133811854d82b46305d68906bae94b15453250924be78a1e8"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eb32e9f381840a968b049a05c16211696ef0116c595c6f501ebd7631d2bb3c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eb32e9f381840a968b049a05c16211696ef0116c595c6f501ebd7631d2bb3c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6eb32e9f381840a968b049a05c16211696ef0116c595c6f501ebd7631d2bb3c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d8dc1b313cd245fad78524f8df2faa9081e7c2e6f4993d0510d082b054a8ba"
    sha256 cellar: :any_skip_relocation, ventura:       "71d8dc1b313cd245fad78524f8df2faa9081e7c2e6f4993d0510d082b054a8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09a522d16d4dd326bbe189f40aed88a65fed97d932d40aaf4f3b258df81afa83"
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
    assert_predicate testpath"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin"melange version 2>&1")
  end
end