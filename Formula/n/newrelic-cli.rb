class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.99.0.tar.gz"
  sha256 "6c10d67cb6d9f83a22d526805162266f9383afd8b852a3bd06ee0e4b50044d4b"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0be523eb43e00bcd3a8db896f1c80bb0dd544234d2953d167c1149b8f224db5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e49c8f41dd4d863a392363e02c76294ffbef611b642794e910078b35ccd7167c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69fb8cc3a752867a384fdac902544f623f518f929c453b210716888a1bfe236f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcc714ef953023d798efb8c39ec536cac0fa8f73a911efb57a57575596924b5c"
    sha256 cellar: :any_skip_relocation, ventura:       "da1a13f17b99186f47785e6ea1ab40c2922ba1125672cc87e83167be9c67af38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae21526124ab69bc214205fee007f2ed38bdbd6a3d977c3c7da84b94250e9d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8e70e2431a69fdb45840b4b8b73e57d7bdc9985f793193e066b94382d35a8d"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end