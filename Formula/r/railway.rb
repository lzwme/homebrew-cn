class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.4.2.tar.gz"
  sha256 "92b54ea87168572d4070afa9b764d7957ab424e139f816837ee6e3f3c5ae6ea7"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c78ce7646a08f0d81d3e1e4243be4d712141d5eaa4fa1321103b56e4e25839d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "341c65c0dbe123cc4c39541b5b0879819e5fdb14a52aa97bbcc61d73c952ff23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a50ca3f9e357e8e9c18371b0f51bf56417bf2da3b42c3925a8df060ebda6f3a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8882a098ffbb9b44e8d7bb21eeaa77d106670d0b20ceb9530743ad9596d3572"
    sha256 cellar: :any,                 arm64_linux:   "75a5a67848303df093bef61115d1c2b51da83b59cd7c1587e33da7e0447c7f79"
    sha256 cellar: :any,                 x86_64_linux:  "0bb0adf32e5c89628c01f2ccc609548ff734fe968224e11d13082c8cc2923891"
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