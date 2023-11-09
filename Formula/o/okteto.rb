class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/refs/tags/2.22.1.tar.gz"
  sha256 "063c406364bd2b9ca872be75cb075bb8823d716e58bf85342fa6fa3e30469dd9"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e059796b1b797e33e389bcbfb1632ea526cb0500dfa24baaf25a6eee8ed03e3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ef1e43b0d1ed7f13e819f5c747a44049ca1db8a7d1515ebe1c31cb3b3ea7cb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e73ad0c3b85ce9439dd49e4e1ebc82f456ec52081f0db92eb63f5db64e039b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e761ab69c7d20d1ebb58c8769db8d1383e7ed4da90f4f476732f9a890e2248a"
    sha256 cellar: :any_skip_relocation, ventura:        "8a4238d60558125914f60a639ea3419de615900f0d1958a81e482f194518f12f"
    sha256 cellar: :any_skip_relocation, monterey:       "d3a787c076bdb7f9ab81cde2753de3e0f8649f2b99220aded131d146d023a135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb249c06567ac12d85b26ab933c185965f094b7e5e8c785ca1aef6ef5bd6a3e3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end