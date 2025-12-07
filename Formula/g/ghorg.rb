class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://ghfast.top/https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "e558fb63bda6a6af3951cf79778905c440cab093f33612d33184f24ad5ea7cda"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f97a23bfa6a45563ccd336c8a33b69a37b298a999a757cb361d968628af4bb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f97a23bfa6a45563ccd336c8a33b69a37b298a999a757cb361d968628af4bb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f97a23bfa6a45563ccd336c8a33b69a37b298a999a757cb361d968628af4bb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "529418fbcaf3b4136373c57cbbdfa12401ae57345eccfd34f50cfdb2ef1dd913"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aba9898597aa424373816a67f4557aa6a13938c36cbdb712b9a7e7c224dbb69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2accd19b131aa2fd867e8a9ef1f11472a8081e042af72ccf3874f5c4c4103e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end