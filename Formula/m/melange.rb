class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "38874329a516ba9c810020c584ed97e18b7e163881397a7e651b82de1caf76f5"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "142fc039987986b6911b3e7137ee8790e4ca87823ef2a17c29f1e08c29858cb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cc58a4b58f10e18329109d543a49754c044107390f2e95963efa3a81c77dce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b7af6ac061d9812c2e83e484ff5326494b608b2c02566533130f625c097c915"
    sha256 cellar: :any_skip_relocation, sonoma:        "c474aff4a0265e4c8cf7f8c268be29b9fdb5e167649ffe26177b2b510eb00570"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "537a17a466e2a62dae387ffce6b271bb52eccb5c120daed7b6e2bd273f375aa5"
    sha256 cellar: :any,                 x86_64_linux:  "d73bcc9e7c8b52f42e21ca40a04b88ddb6773f9b7d46f485c1355f9c73f3b00f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", shell_parameter_format: :cobra)
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

    assert_match version.to_s, shell_output("#{bin}/melange version 2>&1")
  end
end