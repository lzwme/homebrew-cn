class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.26.10.tar.gz"
  sha256 "622de826cd4d570cfa84d73637863f2d417d92730c6841ce38053c76eb07bc66"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4627beadedf3f16267298fe9ce0d4bcbeca9225bbf4181519e28b2eedc145ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29cca69f6ca6a221bbf1da13bf2c6003696b96a4c390ff67d01c20c75b2cffd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85bd96aa4b5c542d65509ce2e1954e7fb20cbcc4a52bee1d21c91f536068f349"
    sha256 cellar: :any_skip_relocation, sonoma:        "c22cfee20007a728cbbcd4a380ba4cdfcfd6a521eca327a1cb864f335b7af724"
    sha256 cellar: :any_skip_relocation, ventura:       "0d87c7022a2fd9632d7414e2bf1704cb81af8ba64e12e0b2ba4686cbfd616cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb045fe1407de03b10b9410d02a9ce4765fb6b01c70e3ec728870051cd7782f"
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