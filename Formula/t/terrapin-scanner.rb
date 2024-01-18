class TerrapinScanner < Formula
  desc "Vulnerability scanner for the Terrapin attack"
  homepage "https:terrapin-attack.com"
  url "https:github.comRUB-NDSTerrapin-Scannerarchiverefstagsv1.1.2.tar.gz"
  sha256 "f804944de6a2afa061433ddb9d393a9247e8392bf1eb76ccce92175bceb99dab"
  license "Apache-2.0"
  head "https:github.comRUB-NDSTerrapin-Scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb483633650530ef441081041b46e99ac9f8dba8706db15b71fe66076aa96983"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "448adf0c5f7e86f455ed051a5ff614217c6e79046dcb45586935f8f45edbba45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f298fb7c18ca94b171c4738222dfa8442067dfa9f2db2d7148ed40edc8cff9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "26e0fafe2e5af6dedbec063454eae49d8190749ec8b166776280665bd7b40322"
    sha256 cellar: :any_skip_relocation, ventura:        "d7d1509627ecfa5983b388b0a5f9d7666345174169e183e09508a0d833d296bf"
    sha256 cellar: :any_skip_relocation, monterey:       "0e98376f5a9dad71e70afbae972417c683e40d11c143526d898157be6f76860b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d34715dddbbda6d930b0f786c666643a555f998d3a860cd1c40f225af82a249"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"Terrapin-Scanner")
  end

  test do
    output = shell_output("#{bin}Terrapin-Scanner --connect localhost:2222 2>&1", 2)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}Terrapin-Scanner --version")
  end
end