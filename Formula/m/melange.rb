class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.6.0.tar.gz"
  sha256 "a77a60455203a835cae3511aa526b9ad6ddc6925e421a56e691147fbdb5c4f44"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c96f447aa8dec5a044b6bbe2f90ac91741baf744f1553b2f13182d6770fa7e78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb0c173a3fbc88b345a7e9656384268457974c04aa9d48df5b2144f125615caa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a220113dfee95770287d017b5db5da39f3f2202be5b6462be5c7a05bed59add"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fd5ae4b4576cbf97c24b5caa5c0eac9c62021646bc4c2cea4dea86fead5a997"
    sha256 cellar: :any_skip_relocation, ventura:        "8572aa24d0175346aaa7ebf97da08f7922c42524784f189384025d259c0742ae"
    sha256 cellar: :any_skip_relocation, monterey:       "039ef7c8a9b99a32f77612024fb9f45153fdf13cb4fda005233359707ce45f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd8eec08431c26d503f6c99d94f53cfe428454a13f7767a88569b919fff72e42"
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