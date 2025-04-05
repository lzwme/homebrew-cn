class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https:cooperspencer.github.iogickup-documentation"
  url "https:github.comcooperspencergickuparchiverefstagsv0.10.37.tar.gz"
  sha256 "fd817cab05b5abd847ddb173a63e8895b933a197ef16dfdf5dfd329378b4ff32"
  license "Apache-2.0"
  head "https:github.comcooperspencergickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d5cab3765637333e3f90333cbf4e23da0eb6db02a3f2f724ad2a7cb412e97c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5a2d66e822faafd6df05ede3cd65cbfce3bc446b36cee7730cf37c36f75c75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14f969e55fc91e50ff8b9d43a68e1ace4b04d7f1e84031b5aaf011a3bad4b8c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd465e651a4955420b13fd7934b92e27b7606757254b1cbf739d7dee1f92cc6f"
    sha256 cellar: :any_skip_relocation, ventura:       "422404513c248b72fa17e1afe559417ac740d564d6727670ad79dab2472925d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffa85cf447b48499fc25461f8c6b8f4d9b4733de13b0fb2e4777de05d035f44c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath"conf.yml").write <<~YAML
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    YAML

    output = shell_output("#{bin}gickup --dryrun 2>&1", 1)
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}gickup --version")
  end
end