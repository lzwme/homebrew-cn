class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.15.12.tar.gz"
  sha256 "37b734976e800ee1526389db64cf9c8ea919c1295aa56aab6042cb2a4c5c9227"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27151f4fd06a4f10a22de1ba017401c51d7934c69ccbb7a2d8496cc2afc3701a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27151f4fd06a4f10a22de1ba017401c51d7934c69ccbb7a2d8496cc2afc3701a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27151f4fd06a4f10a22de1ba017401c51d7934c69ccbb7a2d8496cc2afc3701a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d429df62db20baee81f1964ad502a35a01d8b46458f5418d874db275eb9480c3"
    sha256 cellar: :any_skip_relocation, ventura:       "d429df62db20baee81f1964ad502a35a01d8b46458f5418d874db275eb9480c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23d8464236d977512531c2364e4ed2e4eb13f445a5a50fd34a1f6d916f992c44"
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
    assert_predicate testpath"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin"melange version 2>&1")
  end
end