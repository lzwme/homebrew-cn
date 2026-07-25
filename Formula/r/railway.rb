class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.28.1.tar.gz"
  sha256 "8ffa46aba11d98b6de297e92896640c6325cfee81e289548e74dcf1465bb9fd0"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43eaf5a1a74657157eb20ae0ef4580ba235d9cf86c339c1cdee89f9ab0fd3268"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60b8d1d313fe0cfcd66343a7fc7d293d3333bd8872a32aeef3df16e902d5cfc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6243a60515adcb8c0fa314f34794ce21ac9113b1bfc4d8743217f6d697329392"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3ab2c73993213de1f9727a585a90df42a4f84c86934d2544898dfc4fceb09e4"
    sha256 cellar: :any,                 arm64_linux:   "6c408dc4d0c81816d99841382289906d019b16e7300d02099a587db7e278e924"
    sha256 cellar: :any,                 x86_64_linux:  "af245d38ce4d7a75a0e70fee34860c0294d9965e26ac9beafcc069f451ad9da5"
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