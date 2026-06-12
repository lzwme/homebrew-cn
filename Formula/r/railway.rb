class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.12.0.tar.gz"
  sha256 "4bcea4c8b24231e4908644fadaa27502bb351bc7fb2d63fd7be041dd409a47de"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94414d9e2035963977e2aa1e6ce31daec01d6ee2aac2ff8cefad8fdbc73e59ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82f9ceaaef08f8e6597ecca8207c8dc9f76b4829984651ef956e45aea2c963a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c10fe119fc990a1f41259457b4dd68964e5eef87512bda293a33960d04a27a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1467fa006e9be8c7e25adc781d81a5e1075fd5638980dea58b9b09aa8dc157af"
    sha256 cellar: :any,                 arm64_linux:   "47b4d281453baf809c6134ceca6771e5ca392ae43c060afe036a35032d6f588f"
    sha256 cellar: :any,                 x86_64_linux:  "fa507db565db7bf3f5c61d288ad62654f9630625101a21d92b220a4b35cc210c"
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