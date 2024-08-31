class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https:cooperspencer.github.iogickup-documentation"
  url "https:github.comcooperspencergickuparchiverefstagsv0.10.34.tar.gz"
  sha256 "9e7f99fcc209524ca8e0fbc15d601cb0a7350fd2f9301fc71aa452123e6d0648"
  license "Apache-2.0"
  head "https:github.comcooperspencergickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84d1da9ff75e46a20ce2b7526a75755d30432c23e5940e9e09371c95bd9cebfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84d1da9ff75e46a20ce2b7526a75755d30432c23e5940e9e09371c95bd9cebfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84d1da9ff75e46a20ce2b7526a75755d30432c23e5940e9e09371c95bd9cebfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfc380bbbe8d8731484cbb861eeda688ef3c8ec65a0b3d3337a1432d18a29c01"
    sha256 cellar: :any_skip_relocation, ventura:        "bfc380bbbe8d8731484cbb861eeda688ef3c8ec65a0b3d3337a1432d18a29c01"
    sha256 cellar: :any_skip_relocation, monterey:       "bfc380bbbe8d8731484cbb861eeda688ef3c8ec65a0b3d3337a1432d18a29c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde950c0ec1583288019eb2978bced0e50f8432ab9087b50707c53aad9ca4294"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}gickup --version")
  end
end