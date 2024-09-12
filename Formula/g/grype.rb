class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.80.1.tar.gz"
  sha256 "307c2cbe3e70eac55475196b2d52bd60642693fe654544545f7944db3026a7cd"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b79136f6048d0039c11a12b350a0f57e06c32f0c3b13d78626538b20de3c3c93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41356d0a33ff27f751322fe0836fce84d077417c32ac2bfab2f2e3b2f43d64ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b811f2a111f2b3bd87daa2f7426c94921a8f6f7b8ab7559d35a60894b3ac7aca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b467b298be74de422be3c5c7151744ffa963844f09792e67b942853db062aab"
    sha256 cellar: :any_skip_relocation, sonoma:         "84a4d74a463c6e69afe1c5077fc53bcabec1ee711eac8048a286bfe2d01cdb4c"
    sha256 cellar: :any_skip_relocation, ventura:        "0ad5769ef536022a8504002844ea03e1809bc185a370b22bc6b6c15854c6a26a"
    sha256 cellar: :any_skip_relocation, monterey:       "f309273f226418b167308c96482470d5ab888b24a2286bcc830d1c235aa6055e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "118bca4847eaac76bd41cb808224606998e8ca69692cb9d9e3e009c32526bbad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end