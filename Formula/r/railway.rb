class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.30.2.tar.gz"
  sha256 "6bf10cdc6b57d025ee846c948633d9f596ea7d5842ed8edaa4e7af9fd58efd31"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38a5450f4a1b641c59aea3f3803a701436cc688c0fa281dc9c9a6c4a814fba61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ab884da2c1ad615cce064bff93c062ee03f576adb22e22563b741f9c6cf1aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c005564442d8a44f8556f30d28c27d0fd2dd7da8e51ed853361781c281a9d6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1176865fa4f5bc8d69b044642df392823c3348f6680965e4c7b0a3fc5fc8a1fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8268b7d1d046f8ed821917f611dad65b0f36b689dec9ffe127b6a4f5bb78046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c232c81b75e2827a887d46d20b9a740ba0cfced798a5e248a68da1da5e6b56fe"
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