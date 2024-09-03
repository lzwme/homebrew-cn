class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https:cooperspencer.github.iogickup-documentation"
  url "https:github.comcooperspencergickuparchiverefstagsv0.10.35.tar.gz"
  sha256 "dcf397c4c253858cb279acd991e53093e28e30ab1557b770bc2102599312c502"
  license "Apache-2.0"
  head "https:github.comcooperspencergickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5510a8cbd95599815ee44c6f00942232bcc471c2bd9ba290346bcf10707a899c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5510a8cbd95599815ee44c6f00942232bcc471c2bd9ba290346bcf10707a899c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5510a8cbd95599815ee44c6f00942232bcc471c2bd9ba290346bcf10707a899c"
    sha256 cellar: :any_skip_relocation, sonoma:         "73b622524fd9e968e6e9bf42b3b19cefcaaab7ef213bf71465e9a2fe3ccf7dc6"
    sha256 cellar: :any_skip_relocation, ventura:        "73b622524fd9e968e6e9bf42b3b19cefcaaab7ef213bf71465e9a2fe3ccf7dc6"
    sha256 cellar: :any_skip_relocation, monterey:       "73b622524fd9e968e6e9bf42b3b19cefcaaab7ef213bf71465e9a2fe3ccf7dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ff5af6bb8b3de0146a361aab84706ad4d6324e8d542e59713f8312d58c56bb8"
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