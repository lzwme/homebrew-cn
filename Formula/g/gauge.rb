class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghfast.top/https://github.com/getgauge/gauge/archive/refs/tags/v1.6.26.tar.gz"
  sha256 "010ee71d5235b3e1bc4ed04afed347555d9a68ad40cd732f85ed95dbf980f4cc"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f34cc4a7c28e67081e866838b393d80003a56cd2c4aaf5ca0a0b0fc7f9aa18eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d961caa36e68846deab064dd546a4887b911ad44e1700569b85dc23146c1fa74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2408a97a024614ed0a492765849e4798434eeb4f152669f4da25e66dc5616a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "043384c1c763380e15a36c8b9aad4cc1e2df84541a622835da46506e574c5f58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0550c4d0f5b1cef020593376007b87d82751a7c9ba0f3bbaa417f30cb425ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "161b944f0704db158236b4f31a0b74b0772adb7f68a627813f5f07ebf4f917eb"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix

    generate_completions_from_executable(bin/"gauge", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end