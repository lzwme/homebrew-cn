class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.17.1.tar.gz"
  sha256 "68681ee61dd3b4ed0e76ef4395e5ba3f8b65f244a993f0a53c0ff7f85cd419e1"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c100516a9a505bdb85efaa0dea0d2d5a2ac0f06c570ff268ab0deb4fdb0eb3da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdab6bfa0ea8927db6cb52aacc07f7f1df1e05c7ca7119de1d7c07c8331e1d5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5d964e69e1f6e1620da4d63100a751d2886ffdffb5e8444ed2c51db4bcb6b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ba5d1876a80e285ba1cd269be73901680a6f39523013da676cb59163cef8bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13ca924fbba894f6e3d4ba222deabe1b38ee3e0553276c4526ee7a910c59be46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "603bad074e45295edb59034d56295f5b0c50c30eddf18e2afaa3abc427e11fdc"
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