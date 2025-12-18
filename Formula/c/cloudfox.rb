class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://ghfast.top/https://github.com/BishopFox/cloudfox/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "25cb07af8dc52a546a363072a32d6047125a49bf437bc1a361b2a16eccf8bce1"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd0ac8e28a5a01c82c40dfc010ccca1f663d07dfd463b7dbf47372db383ee628"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd0ac8e28a5a01c82c40dfc010ccca1f663d07dfd463b7dbf47372db383ee628"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd0ac8e28a5a01c82c40dfc010ccca1f663d07dfd463b7dbf47372db383ee628"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8a6718041bc53c4d7f99b651343a171091f854e6afdf2a839da480b2084127f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e03a5b4c501c8732a0eb5c147df8426cb3542f0095417952e78e90fae63f2345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "463891fbd39533502a27b25a39122bb882160fe5bb44d4006caf341a28e4b85e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end