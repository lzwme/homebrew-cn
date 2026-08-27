class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.9.4.tar.gz"
  sha256 "8a36292f3e63fd5408c3232688a8e257c159c9f9ec08a34510e1ae2b40559885"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daf6fd2cfe43aae0fd66fd83cd3276ab4f302b436f5ee78f5e2da37bbd44d8f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20ed65e7e0fb8b58d5b7e70092a7610f88f34971ac9a604112081a13fa5aeab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2380ce07a452ba4341085db3860d956d4ee323b0117b9a864ae5f04bc70f0e34"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9b7d19b90ac16674448676815ee324ef082a2dd91ccd47123250c9ccdfcf177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a45129e485107a28a7ffbf6b940a03c21bea441eb74b984ddc5d5687ea401e6"
    sha256 cellar: :any,                 x86_64_linux:  "e872604d5a3f656beced995d668afbe217f72db26852e03384769dfcd55f185d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end