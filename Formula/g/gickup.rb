class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://ghfast.top/https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.43.tar.gz"
  sha256 "fa0ac4a762cc9f766ff9e31e0351b6f9af3bb19b811e9d9285375ca5992d559a"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f139a875a441646c87d7c8e6519819c13a7da5f34ba7391008709dc5da52c48b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5bc80eee0112da7d51a01e9684a98ea1e619d81f7e037d3da919de43b4e1ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58d2ac2600b82bdadfe8125b2a270ef6f7dad2d28552c66c7a4b73f428138a66"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f8239c2c8af9b848b3818a00fff21fa84584f6ec2a8e7131e69a0c81684c1a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2de1489c7d6a2d5ffd69216b1767d9f73901895716ffeeb8bff51890f83b4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05dda6b44d28c67e0c154fb47204ca36c176faa5524851dba6b8a5388a6ddeff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"conf.yml").write <<~YAML
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    YAML

    output = shell_output("#{bin}/gickup --dryrun 2>&1", 1)
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end