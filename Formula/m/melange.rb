class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://ghfast.top/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.50.8.tar.gz"
  sha256 "3acbaee920db426a8e5f864e070d5d813e960184add3c17901deb639fc1252e9"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fbc5415c92c59adf59c036c283ea4e3fc06a2d0a0abf7c552611f0ff16b3c7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0159426a6b339389add21fb288df92e975c38ff7483e7e6ed41894e6435fb16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77c26e97678c1d9bf2943df9017eb996c63450f4f4f8ad793a9e143aab900452"
    sha256 cellar: :any_skip_relocation, sonoma:        "5239eafddc07f870c47c541f134148bbbbac1906a346e21c09b1fa8b93e88b4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c9b459c82503238ec6bba246b98c8c15b1060edf9e57ddaf26142c9f0596aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "242f1b6a08ff319ce50fee4ab11cace71dabde4446934eaf9007d816589835f0"
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