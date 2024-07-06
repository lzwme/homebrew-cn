class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.10.3.tar.gz"
  sha256 "5159cdce6ff3c442ee27c54019ec89234b5c333a759c1bf5290752eac2eda735"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a912d1893f77bb754d01ef4d56444c8fd40bb02a72117aeaf24bacb55883ff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e000ffcd85374330015271efb302b80969dbacf3f2970575a82615166b3278a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1609796f705d7405262d2f510c7b6813afb387309d3f8305b0a807c34c5def9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6252178da9d42957531297474a0d576431a1e7593fc3b9ec6b455b509c11c3d6"
    sha256 cellar: :any_skip_relocation, ventura:        "7365e2c39a7f25b75d193e7cfe5283811f4c74d8f06fd5c808080b65d58ec47f"
    sha256 cellar: :any_skip_relocation, monterey:       "b6540a44e3d710e9c567282f486726059a1c996d7b1f1e6ca5e2612ea52ba4d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efba0fdd5918d4ed8427fb8ee3d386adb0da662bc74c154fff8c9a7dd44a8bb6"
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