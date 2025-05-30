class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.26.3.tar.gz"
  sha256 "dacfaf8b5f32f3103614fef341e4ede99b5a2416992ccec5423d674c912e1145"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7de6181782b6ba6cef7aaa6a684ff2fa231a9878055e479a249ca11c9901c5c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8413ba1e904379cbbe35218d7bd7d2324d0df3adbc4cf74660df476591f96ae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b991dc615e96cbcf00d6cf5b9b89ae9b5f645726e47676f9fd09a00bea81580"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb442a4ad6db6481815a93b00df5fa58f03281451c560d89270d87906d1a8b6d"
    sha256 cellar: :any_skip_relocation, ventura:       "e847b8c75e365f6352d72cac8f15deb7d45be27ef5f6051dec074e6153393c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a24280b73ec885163d1d1a801fc3269e60eaee301aff01b1b929b7337fe7373e"
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