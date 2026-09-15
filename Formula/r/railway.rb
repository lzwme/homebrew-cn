class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.57.1.tar.gz"
  sha256 "391a7529f347478b9e63dc60452654fd7c93078d095884e7bf1b166a9bb310f9"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbacb3007d0ba3e82c78fc3b97d3ef019106cbbdbc4b910e78cfc9ed8c9be096"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58bd8487b4a15a2708962b7c3aa0decf07356df9839856ffdad8a8393a7faf91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "339c7dbe260c48e082a41ab16910311af1f236f868e09f53ae0261aefcaad76d"
    sha256 cellar: :any,                 arm64_linux:       "6daec360e56b9c7ded0f2b2ddbd932c2386a7beca1d4741b995b57e92cd1c5ec"
    sha256 cellar: :any,                 x86_64_linux:      "6d1bdaad543e4af28f76d9c464c8182c43cee2a76eddf5b09fffa9213ef297b4"
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