class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.39.tar.gz"
  sha256 "767b3f405d8abfe02197d85aa8e8af822e00afb12deff5342b223843b838e23a"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f3c5dfc2821347800deab32a9a566472ff5df76244fcb9f5c929aad41e8429aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a9fe6fb944596cd465c420f7e0d75da486c48a10de86f87da62106351fbe29b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f58aab8eeed9f312623599f819597d1e5a9a8b29f58181a07dc052b39ee8b6be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bc9d4cfb4748c63acd152941deb587c60e58cc129d69288e0011274c1a9238e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd4b6df29eb349fc23c8bf957ea9b1bbec1f0cb9da9e8ba0f42bdd8e3da5b26b"
    sha256 cellar: :any_skip_relocation, ventura:        "aa27270a6af5f4f63076758babc9e490acdd17ea878376909b2cf8551bda5380"
    sha256 cellar: :any_skip_relocation, monterey:       "d9c31d3eaed1fa3411ece0d4a7e0e282694a083b63b71ecd71cea18bc13fc2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cacad7d8406e96a074b61fd0e0a401e5dc4d14d53380780ff6642fb29ead2410"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath"ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = %W[
      -s -w
      -X github.comopenzitizrokbuild.Version=#{version}
      -X github.comopenzitizrokbuild.Hash=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdzrok"
  end

  test do
    (testpath"ctrl.yml").write <<~EOS
      v: 4
      maintenance:
        registration:
          expiration_timeout:           24h
          check_frequency:              1h
          batch_limit:                  500
        reset_password:
          expiration_timeout:           15m
          check_frequency:              15m
          batch_limit:                  500
    EOS

    version_output = shell_output("#{bin}zrok version")
    assert_match(version.to_s, version_output)
    assert_match([[a-f0-9]{40}], version_output)

    status_output = shell_output("#{bin}zrok controller validate #{testpath}ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end