class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https:zrok.io"
  url "https:github.comopenzitizrokarchiverefstagsv0.4.45.tar.gz"
  sha256 "af72245e719bd36554c34a3b9446200dcc7a264b832221378b208b4901d8a5d6"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https:github.comopenzitizrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dae68381256ab752564b2bfa8287b0a4a9e585b126a30fad6142c7c5536f0fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f071bc7c15b835103b2df12e806cf8b6de694a51c3c17d83b0c03b4e2fdfb08f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8b2694ceeb2ffc21866b42afa6f3e11acdc442d6d8afd4ffb39f946594423cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b23ad0db157461772e3b76d6721a227ce7cce78fc8417752565bd38af5aaaf3a"
    sha256 cellar: :any_skip_relocation, ventura:       "f1b7e0da3d677f5cb535f899cb8249b71ec708c8ec9677f84f6f10ae4547bd9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "455d1457479218ced71fb9e0bd62e9fff94b8a15e7de3842ad4c1f97d5d95514"
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
    (testpath"ctrl.yml").write <<~YAML
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
    YAML

    version_output = shell_output("#{bin}zrok version")
    assert_match(version.to_s, version_output)
    assert_match([[a-f0-9]{40}], version_output)

    status_output = shell_output("#{bin}zrok controller validate #{testpath}ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end