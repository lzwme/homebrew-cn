class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.17.3.tar.gz"
  sha256 "eabb251330a4af1f8aaf75f0b3c5359aa6d4f35e939b7bb439c3dec8e5c870a0"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fadbb76a70a0c989e7bb666735673c087726f664c24880daa8b402383af8dc0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fadbb76a70a0c989e7bb666735673c087726f664c24880daa8b402383af8dc0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fadbb76a70a0c989e7bb666735673c087726f664c24880daa8b402383af8dc0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "df6d5f07d2cf1050f8df2285c84ad10dcc3628f52b97fc6390ea7be6dee0f490"
    sha256 cellar: :any_skip_relocation, ventura:       "df6d5f07d2cf1050f8df2285c84ad10dcc3628f52b97fc6390ea7be6dee0f490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab25967e1a4e77c180c062ace750eb361d22c86bc5e284284e72d59a95fc9350"
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