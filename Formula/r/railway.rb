class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.66.0.tar.gz"
  sha256 "2c7ffbd19c0a285272380798e71a17d0a323724cc13262761fcb3c6121ff3e40"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99a582c8528d1e9c1c98f876511d92647da560e59e86ef5927b3ebd8c3eb3868"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2619b4cabdf0b6ed9133d79288a8295110008c1e16e2eaf9003f2777d69fd798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ede05b194e9faacf902fb60a5ae0f7e10c6cc89f544562417057b934430b3439"
    sha256 cellar: :any_skip_relocation, sonoma:        "606d7944d8a21019d23d4e60523a76ef2faf4b750ded87b3c526e81a2768c02e"
    sha256 cellar: :any,                 arm64_linux:   "53719596abd2b7b24d1d9a135d73a1cb54488c2f0ab87992aea61aec2c6424c9"
    sha256 cellar: :any,                 x86_64_linux:  "9bb5f976e49a42503a1736cfaae149aad7fd38329a425c529f77ef79d04bc682"
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