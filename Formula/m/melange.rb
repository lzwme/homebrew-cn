class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.17.0.tar.gz"
  sha256 "0f2f4c61b032c92d5d7b52bc98152863cbff9457545e520c9a9c737d1ef1f8f4"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d0c146c3a57d058dd17c21a1f5c3d02645bec908d6cdd8f33271c41a9ba88f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37d0c146c3a57d058dd17c21a1f5c3d02645bec908d6cdd8f33271c41a9ba88f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37d0c146c3a57d058dd17c21a1f5c3d02645bec908d6cdd8f33271c41a9ba88f"
    sha256 cellar: :any_skip_relocation, sonoma:        "567276e0abf5a8f942f7fec776ffe410533624581a4aa2da0cac8a6faee98ee2"
    sha256 cellar: :any_skip_relocation, ventura:       "567276e0abf5a8f942f7fec776ffe410533624581a4aa2da0cac8a6faee98ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "765f317cf7dc24c088af30d1d2f01baacd8a9252dba9482c4a1e9f647d774b8e"
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