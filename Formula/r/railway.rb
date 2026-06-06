class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.4.1.tar.gz"
  sha256 "530ea07503054ee614104d6e45938de77ad2848ca1e3121029efbf1298a8d3a8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e8823ff4156ebc4917e3ae338eee419a9f373ed01ceda28ddd9bb889535beca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "543e446ee7a03a33a233edc0111b457fa79ed28dcad64fdf60e6a0201989cfa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f674d5741f7a2af86025018001948903f54af710eb6447d7aa56ede4b501d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7733e9cfb9750711fabd4fcea05f7c3e21c361ac22b62b4b0f287bd85f158d86"
    sha256 cellar: :any,                 arm64_linux:   "9f8b2a770b8198ed9a585fc50a177bebdfc808f14ffd166fb9f5bf7fdfbdafc1"
    sha256 cellar: :any,                 x86_64_linux:  "e9e58f17c61fad213a80a8763db0a0acc4949686366cea65ab2db4bba16e4545"
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