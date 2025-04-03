class Melange < Formula
  desc "Build APKs from source code"
  homepage "https:github.comchainguard-devmelange"
  url "https:github.comchainguard-devmelangearchiverefstagsv0.23.4.tar.gz"
  sha256 "7b59b5b93a3ac32591397cfdb2271be726a4ac803e5ad01fec9f287ff2399fd5"
  license "Apache-2.0"
  head "https:github.comchainguard-devmelange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39d064f48dfeb34c7a2d9edccd98ebba06020d51e3db63e105070e9a10a685cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "770b9efeb40de0a929b6d1a4a00601cc5cd96b2fa173645e6f636dce82220916"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e9a0411fa7939101a68cb2524a229a2f30ad8e417a08192b35fd2cdbf0530b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c0156d1caf4dc05a0b97da3d2fa06bc527dc494a1d78e3de3075922b31b7e25"
    sha256 cellar: :any_skip_relocation, ventura:       "775da1caf0c87eee328f26503aaa4e1f55ad4e36bf750c98d537dd97a9609085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fde5d4446bfcd7569535a94b53b4ae97bc6d7ef77b09eedf408279eb903eb163"
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