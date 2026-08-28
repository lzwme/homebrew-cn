class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.45.6.tar.gz"
  sha256 "c9230b67a7cc1e384a6235b994dd5b54405ee2f5ddcd4036c3c888faa658c924"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c128bd1e4c0b7ba2128ecc9cef3100a0868ef85914881656f7e26c927db977d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86870a8ad2381b4e9725936ea11219b7a83864960caa5911af10bf7d30b940a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20f97684089e9be9431edbb575b73e04e13e3635b879bd91c1ba550bbfbf705a"
    sha256 cellar: :any,                 arm64_linux:   "83cee63717e115c6e39145a688dfc92b08eb4c9ea1a40bab4ffc5e336a45d3b7"
    sha256 cellar: :any,                 x86_64_linux:  "0041142ebe16d7f99f36ab7b6ce6f8b2396a41168cd4b6fd57bf782852445bcd"
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