class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.37.4.tar.gz"
  sha256 "630e3e61c1327be2409419780014d874f0e8b0d42473d828602adc9a713cb4cd"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "109516f0dd72a019c363639906c39672ab7fc90c4ea2c2ba22418b3c08e17d67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76fc0f2506638cae28db5dfae92aa7564d8a5e981a59f60b227aa25c4fb73f24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90ab710d2f31e226a435244281e329ea373702d947ef6887dc682359f67bd575"
    sha256 cellar: :any_skip_relocation, sonoma:        "aba2295a1890edad8ca4217394638027067fca876b7eb8cbe027136cdba6de0f"
    sha256 cellar: :any,                 arm64_linux:   "3538b512bdb4ddd02383efdc0b87573661765a03b60f2016bdeadb4a6ca9cccb"
    sha256 cellar: :any,                 x86_64_linux:  "d8ed17925a10eac60be8373a46f97338cca3b1f3487631b1f5b36a32c47bc1de"
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