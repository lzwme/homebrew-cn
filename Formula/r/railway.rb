class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.64.0.tar.gz"
  sha256 "62302d0017c85271d1cc123a32001c57c35fdc406b037154a57ce7ea35d4d8da"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a969b6e73208d525a0d34a1fd5b5c3d4c6908385cafada8ad95082f2d031d06c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5413ec29b44e9934d6317a84732275a9d74626d5fcae3ee82968a55f74a2eb72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20243079fadeac45905992db7f715d335f752cb84fccbebe0d574b79809af560"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ad1b4b48a45ceb0866c23eef2c705b312e98848bec63b29383c60bde8ec87ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9061e64b97c45bcce5eb0822487f711deba0c567cb57cd0206b44808199c1533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c555005ef66c62a41cd2e34993ef34c1c925a3334be85b273d5f70597d65bcc4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end