class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.60.0.tar.gz"
  sha256 "916a8709b141c1b8ba4507a7f19672721ec6ba40bbfb74443138354e60b27513"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cb6ef415e4745e59e4efefa6684f0b17d1974b98592936e176d80675c0a95de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1999fc11f24e565c2a628f92fa1ffb79e52503ac73699faae4affcd5524b2de9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "165e24af126817b6794caed27655e6ae53924ca1238b509df44395d607a68818"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9d6550f6e9ae64ae0d014ac26d39f0f394496da22ab76b459105df578b70f9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cec93ec37a9d0cf2bbbea68b8d7336f217e72a2ad75d4e1229ca150d298b6e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b3c67a40cf4abf9605447eb09f31c4744bfcb55ee3d5c46456e4e5775be110"
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