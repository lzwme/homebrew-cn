class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https:github.comnginx-proxydocker-gen"
  url "https:github.comnginx-proxydocker-genarchiverefstags0.12.1.tar.gz"
  sha256 "c72ff4fbc88502e2759a6135e6af1baec7d7385f6d735e016777e24d75a68cf2"
  license "MIT"
  head "https:github.comnginx-proxydocker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a545375b338181904811ad18889e3c9f5cbabdc83890eca6768437e127c3366"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74a830868aefbcc129d5f09f0333332e5a0184e5a39abd1a5be1f68e7bdf8d56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a6a325d95c40358d38c144568d535f8e6cbfcf9161a0ba273104af48f89d770"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a977d3648f71c70badd306e56f6f2a0644f0c11e2173d6870dcd7387f223a1e"
    sha256 cellar: :any_skip_relocation, ventura:        "73cb852c53d0ee2a63d1a2a664ff16d025cf82ab629aacddff1b5cfbaadf36d6"
    sha256 cellar: :any_skip_relocation, monterey:       "064709d006ed9e60491c4855a67ca7edd534a40898794e4b24d30629d85a8c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbe31c0ff2c7ed4fed459c4c6ea4f9b558a9396a4cff70b4404af33d9786cf9d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmddocker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}docker-gen --version")
  end
end