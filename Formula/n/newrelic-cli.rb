class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.107.1.tar.gz"
  sha256 "bb407e07f63724e2a6c2decceff651ee5e1d163817aafb6596932c4c7fad8309"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60cc832383ab1bba0a3096d5ebc17b37c0d01ed453439be6f8b4143c58426941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67793214e37e6466dca5534d9dbdad79aa2b0cc1409d8e1ab656a37fe204dd9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f38373629f67ce5a02d96e4cfcebc60d1263e1ae22a66346db19cfd48f22c0dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2383def2d84ae51ccfa6a8d6b22e75d656d8a809870e981422e997b1b4109889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad4e92ecd2e19eb89194e938033a8555ba884f52512135950dcea98ed124292a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd0d20a646be72149d1e6ee1cd6e6cb8d250d97dee8b8bad6e41f6cf03f3cef"
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