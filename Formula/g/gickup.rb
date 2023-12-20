class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https:cooperspencer.github.iogickup-documentation"
  url "https:github.comcooperspencergickuparchiverefstagsv0.10.24.tar.gz"
  sha256 "b5023394d13bafda728552b412498ae8e7b5462acf2cc5d4b316af5edd7baec9"
  license "Apache-2.0"
  head "https:github.comcooperspencergickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63ee815f14cf757ba01c5bafeaa4d26135b1491c9687941a43133efe36220727"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b0a88550b54d88e395f2e614a18f8e1d358d8b1d250c88e0d9d0940ad2b187"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48536a9a2f21c9116563f7163e79966a0979e0ff3a12d7a9dab5624ce5e4ce34"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7fb773624a3a41dc3af0755f206e9d56877d8adc951db4b05b4cf622cb14dd4"
    sha256 cellar: :any_skip_relocation, ventura:        "4b14755ff66eea5fdd535bfc9dbec1e43ae15c37c1e0526ae112a710b4c16a16"
    sha256 cellar: :any_skip_relocation, monterey:       "440bed386358ff41451641c7d6f9aac5b256a10ad464c0aa9ec4b4857ca6f72e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "234c71502320d31cf8d36296b413becafc312c801e814ac76eb6fdd2ced0e74a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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