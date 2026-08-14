class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.5.tar.gz"
  sha256 "d23b5088ab7f13fa9a01fc07868496354163ec3e8e7b78fb7d424818bdc4799a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0296cbda2b5d41196437f6079cb7af38d31a657af9d73e89d4547bb52ed37c9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfbd0c2c685cd6ba25f3a33b57e22509e089bbdd9c0fcb7dadc21629fe44a2cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dcf389dcc9ee120c62778555d65dbe6212a4203e32cf7c44ef7cd378593ee09"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ffe8b9dbe8d671aaca87ee26d9c650bcd604cccc2fc49bea500930edb42ea8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdcd320f26dfeeb10e789df8ebf1f32c8e846515fd9e91179ca0a51466b86b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fdfe3cf395efb49237d1dea0c5248651278dcae27db10ccc7b19cc2005af511"
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