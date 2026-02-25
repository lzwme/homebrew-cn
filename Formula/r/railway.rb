class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.30.5.tar.gz"
  sha256 "66dcf4028c0cb0c560dd44147134c210870bf1b94f2a50ec8bb9fe962c391245"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b50ca01518a5c04f6017734d1a9aa8051640fe27ea5100ed6b74649af3e08e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba0719236b75abc18302b353cfe7d183c5362771fcb22e895b1cc83f29057e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12872260ad7ba864a59689f8b76bbb070ab5564b59921ee10ec9dbe3ffc73951"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dbceaa97051905d0fddd3a8005e876288a99ddacf598e4433e6ea588d207d6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59c47b6487577a4dff6f66154f2e760f4945f6210730d95ae7d8898db94ca5ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1edfac6238d631ea2eeb3b1cc56b83d942937baf0213c6b055fb2c9812d8e34b"
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