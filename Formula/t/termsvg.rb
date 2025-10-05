class Termsvg < Formula
  desc "Record, share and export your terminal as a animated SVG image"
  homepage "https://github.com/MrMarble/termsvg"
  url "https://ghfast.top/https://github.com/MrMarble/termsvg/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "0055e9383f726887546182966033ec9ad8be2fa9b506842697ebed71d2df42a0"
  license "GPL-3.0-only"
  head "https://github.com/MrMarble/termsvg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54909ac9da2dac07008a5b63d2bf9c3a161bd500734e36ffbf3393d3cddd85f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54909ac9da2dac07008a5b63d2bf9c3a161bd500734e36ffbf3393d3cddd85f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54909ac9da2dac07008a5b63d2bf9c3a161bd500734e36ffbf3393d3cddd85f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ac65544ad9f4e2b1f0953232a3184f44cdde9c8fcf8d5c0a9d0329fe87c56a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41b86b1bef2d9a3fb7406ff6211ddb558229fcdcec8e335a0aa14c72530b173c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46dc677152b33ba924b355f803511c56d1ce9e4d1d75a5e07577adebf49b6ba2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/termsvg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termsvg --version")

    output = shell_output("#{bin}/termsvg play nonexist 2>&1", 80)
    assert_match "no such file or directory", output
  end
end