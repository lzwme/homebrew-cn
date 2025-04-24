class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.9.tar.gz"
  sha256 "5c2ed179ddaa0d8af03d0b8e0bfa3af2d1890a6a788a045527d4410bc405726d"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f463926a7a638a7e2c5218507176535bb226f1e948d7522b8871874f711806e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f449e0fe61481a2ef90c13ef5d6e05c62618ca1750920fa26997350b1f28768"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "961c3535e6344a45a3468babca8a08f8347d4e9b09a17a7a633f64cf3f38faf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5893c3784387559cbc83eac91672da9afc1ca67fa450799ae6674c58c8c1d1ea"
    sha256 cellar: :any_skip_relocation, ventura:       "f7f30c4142dd18dc9131ac98487db89d069c8a9355c95e9f8535810e39aba194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c87803f56af32a35234f32361ea2b1d85b2501eb7e696202db16ab6ea55e1b6"
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