class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.92.0.tar.gz"
  sha256 "ce52b5a85dd47752d317bb19a2402c1ac98099c57f0c5c09b1c652bc63a1217f"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5eb04b6a0b35a89a0d92727a619eb61b08c1f8e67d9e5a58993d121c56ec6943"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "222be305bd8780ac18c1242c0c687d5a77bf4dc64bdf5e9c4019925dbdbbe1da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fcf25d20677c71a5a9ff867bb073b58058e59dabfeddff1163c709e44877bb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b1522b0e044ee0d3f45953483121ce5a8672c313cc3d76a67126a52dcf42214"
    sha256 cellar: :any_skip_relocation, ventura:        "822c1bb4e2e28d577be5e81daef388737e36af5da91561dd5a1ae05f9f3aa6da"
    sha256 cellar: :any_skip_relocation, monterey:       "5d86c33a18212bbd9f4fcb63a8b8ca78b9174c2b6ec22a81e1067407cd34d30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13dc7016321d237a72427e88da6f3a9a9928f4c38b8de78dc4031e364488ade7"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end