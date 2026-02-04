class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.28.0.tar.gz"
  sha256 "4915b367760ac8b1b678d69618015a9522aaf45d322812bd050b8d267b63582d"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19ed4c8a4f4342d542abaa81cbbc72325707187c072d035448046fd5da14a70b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f5e61e44dcadd692666a22da70730f67664f049dec7335910ac3d2e1ee6579"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11232f2dc4e2f7f08d4f2843c0120cf46539dca53828a6157f7139e128869909"
    sha256 cellar: :any_skip_relocation, sonoma:        "79b342d998ba494c8d93393e540d2666e53b6922f42a819201678f9e4b62975b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30222a78c9b4221c00b2eadedf7e08b9ed1407b73c357ccc40d06fa7eee43bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9ce270aa3b79ce6bd9adbbf1a53dddac2653ca42bfd99e810fa4cfca4af8ad"
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