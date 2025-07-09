class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "358e5f2415e03bfacb54c09ad45f080248c747862a3050be9effd34e69410f78"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b00b29846a15b572ba7a22b35f0b25b991c01ffc65b4161fca7fdb8de0dea7f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c048c31965e21f8309ae667872e76771b79b89d59556da4d9d5a2270f2071e13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23adbad1b23dbe3032fe6851a18bf7eabe298c536d19089c10e2c34f426d5045"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd1664d140ff26ece9d3a7ec5d070311925e31028e9f70dbf8877bc05f22bcdd"
    sha256 cellar: :any_skip_relocation, ventura:       "8dae9e5f830bdc5301e87abc45c327ad4e60571cf4b5158dfdcbe7144bef4ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13b9faed9ce9cd562c891ac9792223a0159ece0b2b973e17dbc8f341542b4f2c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
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
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
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
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_path_exists testpath/"melange.rsa"

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end