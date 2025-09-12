class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.12.2.tar.gz"
  sha256 "3a67465f72897320097a597cf3529016a5cec931966f737b7d232594547a859f"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b2e7d5d9b531c02dbbc4ce9cbcfaf17d2328146d474fab0c248e4ebd6869c66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b2e7d5d9b531c02dbbc4ce9cbcfaf17d2328146d474fab0c248e4ebd6869c66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b2e7d5d9b531c02dbbc4ce9cbcfaf17d2328146d474fab0c248e4ebd6869c66"
    sha256 cellar: :any_skip_relocation, sonoma:        "44b70c77b3b715218986ee68e50b3c5c296fd98af13730e0dd96bfc80a924aca"
    sha256 cellar: :any_skip_relocation, ventura:       "44b70c77b3b715218986ee68e50b3c5c296fd98af13730e0dd96bfc80a924aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "731c41b96bd8208a3b731993266dfe8259f11f120e6667efb506c225325c3230"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end