class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://ghfast.top/https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "980678dc85b6b401e1c53be86eeb98a0b9da076155946d6d5a4b59eccc9c7e5f"
  license "MIT"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "653994a27f74b03f605264e10c2cea10a270383fdc5122f6d436cd1a4e812523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ddb19ac97fbe8528153cd1b1c595bf08025d3b2fd12402622f4e6f1b158de09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c485022c6219b1958b5dd5dc53516ec3c8163b9d8e2b4a5b145bbbc6652fe8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6f8ab1e9277e26963bd5a8611a2af6d028bd7e3760cf80f65115f9ccaefe67f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27fd16679ff931c576d7414ba71f87e7b12afad617bb5576f46a26c9b2310db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c05b1b72c873968661f320291bb2785d2b10e11d8e30f51673a13b87a3432bee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = spawn bin/"bookokrat"
      sleep 2
      assert_path_exists testpath/".bookokrat_settings.yaml"
      assert_match "Starting Bookokrat EPUB reader", (testpath/"bookokrat.log").read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end