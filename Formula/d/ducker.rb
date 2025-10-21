class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://ghfast.top/https://github.com/robertpsoane/ducker/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "098a79349d68120dd112a03e9a1145bc2ae4934c02d13fc783b1a182b411fd1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5419e45ac22ecd040bca119b3d6c2337fdfe30d05370e8bcbae7070e39a71ffe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93b76caaa0deb07c6646f9084bd7b2b01c90ce4ca3a24c3d3efb1952a6f0ef7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e55b464a81ba560927c80e29f03c3be80c5df7a614ab815ca6281fc6ef0a7aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "19bea8ab36e8903e24225c6ab0d7d60568b9edb979d0de89c857b5016fc64db1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f7ffc770ae57a203bf26db3ac543e675f4e88cf563e555d9b0ff0eb7540ee9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ded4ba88dd7a42732cb5b55f18a565f8b2e27c7088639551ec85b87324388c54"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end