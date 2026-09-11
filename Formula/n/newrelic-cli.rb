class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.15.tar.gz"
  sha256 "b1fb09cebef08621fbc5c6ecb15d2be45cfcad034095b4d8ca2dc4a4b5b77d3f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fb2d1a55a6bef09a1feb9cc4deb2a976b3e384dc581900c93269594ab3071bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f4255f698dcc63373c8a147da99fe9b734a43d8dfb5ccbaf7df5760d695eaef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87afd2debc58456d6386e34952d4b3980672e1b866a8e303980d117e593b6400"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b36527b8d5aef3d831ffe65c60516bc2045f93897541e2fcbaaca1bd7a8d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac66c1758c8ec61455f22566eaf0f808a9fa58c32e3990c63472d5d056c3807b"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end