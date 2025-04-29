class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.11.tar.gz"
  sha256 "d018d6111b436ca0af72ebc62ddb317050835f92817729efb87a047286f0ffc9"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72247854f4edd1cc710fbfb8a7859e8c173054b6cb530b8edd4e65d05a23a041"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0607c3fdd215732288569a354eced74d7702f5f0260d58697a140c2faa624b3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b5117ba60efd798c1265048c33dd2dc243f63f5653fdf3ab14d02db24c7b935"
    sha256 cellar: :any_skip_relocation, sonoma:        "d595bbcc9894ae58f348736f55025801ba445ec384bd4b02f06001ed3efcae4c"
    sha256 cellar: :any_skip_relocation, ventura:       "35edc79cdf7e5b1772f218441f0b5ae0b6adb2c81ef33dab6a11dfc6c77ae732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d1f7119bf196fbff511a5cec6f9e39a92d80cdc8fae280936e451881061767"
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