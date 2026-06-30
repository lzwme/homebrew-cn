class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.23.2.tar.gz"
  sha256 "5f06d6366e76579df707e588f25134f26b6c5bfe51a4487a472fc5b53338268f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93843486147a8c0360e1a35f1cd83422501d84b8542201f158f7acf68f32a369"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f8ca85b48dbca0bbabdffa5e9364b8a301af12b8fb93320a6e1ce01c90df026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c13168d792d3fcca67f919a1d0bd72394339fb5a34befca69039c9a68a33c3bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd35bcddd3b8805d8728cdb903d2ae189b57e0cc5ef55fc41435e51fd5142ad9"
    sha256 cellar: :any,                 arm64_linux:   "266e3f5e1a108b72dec26d45fd6baf1ef46bac26a876b1e8c455756414b4b073"
    sha256 cellar: :any,                 x86_64_linux:  "681d79f583bb600038a0f156efb52b1c38d0ba662d6982bedf574a72086027b7"
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