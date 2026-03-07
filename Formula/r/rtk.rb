class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "22302a32e38e99ff4c297224dee32fd054997d3d2a8f8c9436d44dc91dde348c"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "235613fecda89a08d9e3474d2ea8b78d2c78f875fc8f011cb1a5a2900700bd42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0170094bdbb6a9eb5aabdc93df77874d76b8b40715968589cf059a66ee76996c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70a509dafd6f73deeb9a5e9cc1065341b61ef8a3a81f9acc6dc0e97275786d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a46e6f0b975a4f0feac2de73aad2e593e510e147c4a09b819dd2d0129c7bab5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25586c709ba5919d7c1959e019dd839144ea8842db7d8841fcf45b2c5693b0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60627a500329fec5c7fee96fd2de0c80e0a12d8a7a7ecff9dfe3379e391578e9"
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