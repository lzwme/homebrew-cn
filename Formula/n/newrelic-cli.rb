class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.6.tar.gz"
  sha256 "abe6f50d95acef0145db52764a11cdd5bbecdc0399468536205f9af46333f208"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9412b85a4bc78f84539f948070fc1e7c5cb5717f63449fb738cf59fa30a379e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25faecab11ba37306c9266ffd1e77e332005062a42b38dfe1f7a4c38264362a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3765eb249f80f5fd437119ac4b08ff8beb18a3e4210dde93ad13fe83cbe2410c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c072db6018ff1ca333dc7b2f90fab65efe9cbeff9a2bc533eb5b8a830d05d9bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dab916918f0b685973bd79600d88a57c348680466d88484837f5874f13c3465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb36c1d0c1596be22620dc6666d2ed63357817e56e74a03490196e7e1d5dcb7"
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