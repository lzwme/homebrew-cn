class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.47.1.tar.gz"
  sha256 "88f5696de765f0230953349f87bdd05076b977083ccc52dda1b4d1626b00dca0"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "097e02e45101680e45bfd9db84d72296384263ef26352feaeabc29292acb9242"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66bab1cb8138a960b60340d2cc7e909958d55e19ef232abd76908ac30bb84aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06141611097e35b9f12f549cf5cef0587bbbd87f5731855fd671e106f182aa9d"
    sha256 cellar: :any,                 arm64_linux:   "93bad9d2928e7133fe97c0306b525970c462868eac3b5fd14be6ddc08e3e92d9"
    sha256 cellar: :any,                 x86_64_linux:  "2281f8c8752fea1104af202897fde57def64c96c552c6b6b700e095e453d599f"
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