class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.26.0.tar.gz"
  sha256 "d8c4dde4183b4dfa847d546d502b7eea8691ea7df10e5d4e4ba59613da2f7c96"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f64fc26fe3195e977e83f040632d2ace4c7b7f866064ce1752fdfbff47d2c84a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9908efe547548cd5fd533e0b86372cd91cf0b6a173e3e98376e0224451815a57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07228b3afe774f1fd990661996d64ea7859cc7c97f861e2ff4fc4dca9309b114"
    sha256 cellar: :any_skip_relocation, sonoma:        "84facbba55b9cb00427266623a643bb0b1590f414b864aa3c36e06d55840740b"
    sha256 cellar: :any_skip_relocation, ventura:       "a358a1d6337d5c7aa3cee6637cf124afa914e71c8e7eb1466e280aaa122964b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095146ce9373be05e1c6a49eb2512b05956d7d3fb59d69615ddbdad60cb8b316"
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