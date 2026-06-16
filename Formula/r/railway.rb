class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.13.1.tar.gz"
  sha256 "f63a9a50ff7db303c5bef6e06c85000e45ac191efbffe9083620b987a9d3b056"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ff22252b74e1d64ac4e5703c29643a4515fa186d700fb9317122764428d3de3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e4f79f1dc90e93988850279bab9f9f0cdfc974856b183da54a4a3095de9a77a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09860ea164bf4a6f00de3f0af129fdccb2a3d9747f9b5404ed71cd230e055b0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d40c6b874b0c33927f32fa2732aff3a14cc3a60c1e7f0b8f741b42328ac9a78"
    sha256 cellar: :any,                 arm64_linux:   "249a53a2030d1cb70450036e82ed7d1ec6a8cc7f3a4d50d8373a1a86711af249"
    sha256 cellar: :any,                 x86_64_linux:  "39e20ec975a116f52987afdbd3785c12fad483a6fbded8b50cbdf9f214d1569c"
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