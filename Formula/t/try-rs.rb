class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "21c3c4d3e77684893a4098651f655da89f8f3b6f07e2f8cd51a69d4b40dc2e01"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50e678fa4f7fb2eab5282025cea10140515fc9682f09c2511c9df0197a7a6a75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e99405f5d242ed2356630232c32e62722b3760ed33a632df2c107ded9697dfa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "262184b9caffdc809cbec9b0ef02e1b61be4888e4a7ffa6a2184a69117f6fa87"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c8ee57f6f99321deda9a008c3486d6a2ce2e1d700d716fd55120472b87bfd86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8150bf690e78372727fea4c8c1b3130c3582ef7e2c0a39fa0c238f2bc00982c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3a34867d11070bd499681f4ee5a55620a79d77d39575db48580eb08f9444c42"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end