class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.22.0.tar.gz"
  sha256 "949a7fd7d96e813697fc889f62cf94e11a8d8cac5fcd206cb64ccdf4076751ea"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7de67e00d5d24b70add9b3571b631e19d6dedbfbbe454c4fef9705889446c07f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f745fac2e44ca6096175da7c340a3e144b014bea381e468272e3f44f41ce27ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e0f62954fa4ebe9889c4ce330186bb71cd9e28a0896dfd7ef5dd7beb7699077"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b2b73d81d22bed3fbb6b4cb7326d0d454368fc36ffedbc8965a6671c4c2d63b"
    sha256 cellar: :any_skip_relocation, ventura:       "05812aa278e80538b236ba0b406a2346d22ec50052dc51dc3fce88456b2d8781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a8b10e139e1fb69b10b8c21f2fca5d2201d7c58aa8e8c3f3ee17c669e3d9c7"
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