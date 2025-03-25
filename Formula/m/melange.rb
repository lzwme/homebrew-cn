class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.1.tar.gz"
  sha256 "0e887f1f1dd1d9cf51cb07bf9685ba16d1e3892069fe33a290c1079307b317bd"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c60866489e4a6422d542a35347a28a0c7690beaa7faad19b164af0c4b14f2bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f2ffd76cffda1aa4fa950eb478c4ed59fa2bc89ec872ca02ee38116fcfa2411"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87f703ce917af0e626b964090157e99a9fcb9a041d718bb1f884edfc829e76dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "eab93d5a521c8c644d2db4f9ded5e4a2f32f3342ae49504a0e10cb147e84cc8c"
    sha256 cellar: :any_skip_relocation, ventura:       "c9dc4e1c0eff280ee20c0ec2800de5ace62229771c53f1f082483485f41f2ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f52ef678bf9df7d165c5502d7e6fb5ee12f7fc8f0676fb54aafb855ac1bee4"
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