class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.11.4.tar.gz"
  sha256 "910f8c6d3334d8de750932facf74753677339c7b7e6c07071232a04560ac7574"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "593038398383da015fd6e99c872d79e6ab94e8c601325e7a39bcd1e6a96f3dff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "593038398383da015fd6e99c872d79e6ab94e8c601325e7a39bcd1e6a96f3dff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "593038398383da015fd6e99c872d79e6ab94e8c601325e7a39bcd1e6a96f3dff"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b0a32e965a59e22907918f5bb37f6646b21c662bdc806cd1c7863e0a6a4e75c"
    sha256 cellar: :any_skip_relocation, ventura:        "7b0a32e965a59e22907918f5bb37f6646b21c662bdc806cd1c7863e0a6a4e75c"
    sha256 cellar: :any_skip_relocation, monterey:       "7b0a32e965a59e22907918f5bb37f6646b21c662bdc806cd1c7863e0a6a4e75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac53539e4cb2cb7ff0d3ef98f148c262ebad96629059936b19e3027ba559cdda"
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