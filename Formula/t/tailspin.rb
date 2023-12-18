class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https:github.combensadehtailspin"
  url "https:github.combensadehtailspinarchiverefstags2.2.0.tar.gz"
  sha256 "afa7ffa24d47d6266ea96b06ca9b30cc9898095dd4d077e8fe9618ace96c6b89"
  license "MIT"
  head "https:github.combensadehtailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f73e5286a216647fab5b78e442919a8427ea22224b4139171f03216b882d2f1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "982e90e4f9b4629ff5b27551c7e0c815e36a523d6ea6fcd66445fa0c2d439526"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38842ab19997945e3778693648d5f27cfb1b125faa38f9a382dd6a749d1f4049"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcfa07a163bb4193378fcec200b22d43cdbbb884c451e22fecc64b609f43edbf"
    sha256 cellar: :any_skip_relocation, ventura:        "54139e472f4194ec9999641f0063598954993df98b7461f89473f427bc662b58"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c3f533cb804db216e477b65d2d0430e3e97849bf640f8beb451f83e0d9749f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "536cc837ec45ca6d4a3ae8c1c94e6b55b652f396726399cfab37df0e59943c24"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}tspin --tail 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}tspin --version")
  end
end