class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.6.6.tar.gz"
  sha256 "6a4bf93c8d4096dd09c5fb3afa5c4a9ffa1832274f0ca55dee6980afdb0142c5"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6d9b3c95f8707ad3f7c54baf18b75afc7159a3306c8011717b97c22ae5297b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d96252e781167878eec0a114eaee1d644cfd73f779232a6ad0c5b134c284ce7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca71c457142f5ea9eea1698639b9c5da87aabcd2213acca6d3aea770a9eefd00"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa3c59a49d4a51137bcabe3c0ea34d40a436cd41a8d8cdc1da6a11b80f745e5f"
    sha256 cellar: :any_skip_relocation, ventura:        "27a6662fbc46ac1b2502ad24ef71352fa7c0f10e47a10135cba1365830fbf8b2"
    sha256 cellar: :any_skip_relocation, monterey:       "7f14fb75c47aaf6405498ce8c986d1ddb773b5d69b1f0c9e942b635f35414f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22bbb473028ac2eb8aae10f9d6bd9a11e421f541730e28e66e166a915225f3bc"
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