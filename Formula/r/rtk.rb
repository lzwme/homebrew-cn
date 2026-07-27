class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "2d473072d143daa62dc9e48f20266276cffb77b0addd829efb032336f539e8a4"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3912dc969b48222769c86a23cf36efdfe4445cc5351544244f22f2bd1998c894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "626cb38da15ef9e046facbf9df319fd48e2d28736bf723ee1f089d7afb72789f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc6f071dba0e8155985f05470bb3e8694cf0f8b633697bfe5cc574e12afa0632"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6543842f624c0edbff33455e4770a953def01478c5aeac9baa11b5fdbff114b"
    sha256 cellar: :any,                 arm64_linux:   "97cf00a363091dc7c3b7cf84e427454adfef4ac96668d659ce970642fd9b52fa"
    sha256 cellar: :any,                 x86_64_linux:  "7e3da161a0039c80c6202bc4ac8c70113f620727dfb70e6676d85e616f693945"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end