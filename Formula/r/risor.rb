class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://ghproxy.com/https://github.com/risor-io/risor/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "594fb818f4d994d9e6d898143eef5d9c606d4cac196d66e764e616d3dde200c3"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c087f213b1dad846b927eeb3ae6f754b448d78fcb6280b55e385b14d74de94e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "036b9af4e8273b8c3bc3232f5a770a6e2872205f3a7eff62446b6732f3e33aed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1a6056f19d632d3e4e97c39b89ea476936d3f8aac5cb2a81a5a7b433c66433b"
    sha256 cellar: :any_skip_relocation, ventura:        "8adb39ef1252e99bd6a2952089d094f37dd537b8b9c693c5764b6b661812709f"
    sha256 cellar: :any_skip_relocation, monterey:       "302d539d756c794aef637d8179400b29552e16b0fe7f0e0f7b977ba06b17849f"
    sha256 cellar: :any_skip_relocation, big_sur:        "350a4dde045eb28145b12ea6aff02ee35fdc71f8e889ddd2359affba956e5bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e7e98e12ca3e5ef93702ed3d1ea0b973729f0c924bae3372a83b4acb825f0dd"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      system "go", "build", "-tags", "aws", *std_go_args(ldflags: ldflags), "."
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
  end
end