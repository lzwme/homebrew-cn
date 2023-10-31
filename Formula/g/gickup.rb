class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://ghproxy.com/https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.22.tar.gz"
  sha256 "19cba38c8b586741413695ca9df178c253b12777034b09baec6406cb975b803e"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "077b4095884bf130bada35d6545cdc6bc8aee8bf86a4903bd9c5f57abb358275"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03ca7704c650242838698f723e2e43f0266ab5c150f644a49facfb9b8d4c51ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da3c975bc184ffbf67df990f6a15fdf91f4d56c5abe883a1440f96f6c1aba8cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a927914cd71af76a0338b7bf9f5e44b84624113ce47720a8d7c79f123796964"
    sha256 cellar: :any_skip_relocation, ventura:        "a7825a66b7aebc0b2179062d4df830e469df01877e00039c93600d7003ac4b3d"
    sha256 cellar: :any_skip_relocation, monterey:       "8a5025c074d8bb7f8f033f9c4be58cbd7246964b0649d0deb585049cd3b3cabe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6756aeca2d7307de509638081c0a17b4ec21d8211fa849229eec7594fe194e27"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}/gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end