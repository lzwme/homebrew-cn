class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.26.1.tar.gz"
  sha256 "7504ef2b20fd4bbf85f4b8b1f877f4a69320477ccf129e34f7b6140be7e2a510"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a0580c2f4871cbfb31cd72a3f12cb66fb0b67ce86901848feff11adab105975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3355d072b5af641849c40eef5f97276b095e3b9d3a8a0aed87759c87ca172778"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59773d2bbb0d6e7f5bbeb24e718502e460314f77b02dcf11bc8ddb426e4018c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ca0cd586e64e2edfdfd6dc90535f264e43e487328ebe0c8d07075eb87f92aec"
    sha256 cellar: :any_skip_relocation, ventura:       "beb4519e123417de33bff05d51c47af840436b46114dcd5b537a4caf7b03ce7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "727067223da5375d167604d9048588734f330966d82680b346d947fda6bec215"
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