class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.21.2.tar.gz"
  sha256 "8eb11ca1549246cc83cab1363700fdb00e6ac0853ae2abd832b75d70e724ff1d"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d603441774ef740da4f6d8fd75541687d8f2409e4a936ab158c5eb9208866350"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00ea07f403a06aa01cbbd33daa476aa830f06628fd010700bb9f1dca74fc4852"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3259ba3b23fcf65531ad93ae11e08fc8dd4a011e18ab869c606d851a3da65fe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "67c5d7d9fde8044ae41126389097bda3ae300c2e7d275ddb41c22d81a4fb8219"
    sha256 cellar: :any_skip_relocation, ventura:       "6a49f9feff1573424ec82347f895fc03d8141b448c710f1db33e132c1c722425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c471625fc077e0c35e5bf2256aec5691f0d2248ce69b22881bf2f3248c427a3"
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