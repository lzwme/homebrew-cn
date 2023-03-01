class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://ghproxy.com/https://github.com/go-delve/delve/archive/v1.20.1.tar.gz"
  sha256 "a10aa97d3f6b6219877a73dd305d511442ad0caab740de76fc005796a480de93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64ccaa15a16d959d300474755b10ca35d21b3c58aac0920aebcfe2160c329a8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9e85ebe92b4f75e16dc01a524536f82ec4515cf3b077867228ddb94f4a8bd4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0da05254b0868b3bd954f591ad56ad2e5dd0a371a429593877f932d4b6111c8"
    sha256 cellar: :any_skip_relocation, ventura:        "932cd17b1d87466a1e755db56346ce9fd953724e879628f330a69dea825883e0"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e57b4ecfb290968e28cedd9e445c41472059ac3641202609696f63bfe3cac3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8008caa12e9e775ce9dfc93a6081d4b6b42530aa15884b95e0b50ec93eb5068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7482a316d8ce4eaecf282ef520b6444629884e31c96b21b50421b8d369e6824f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end