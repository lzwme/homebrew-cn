class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.15.0.tar.gz"
  sha256 "9129b4adb26eaa30269e83a8c773f43684d67d1afba4ea58ba10d566c619f3df"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57101c5e0912f079de35f9f22176fe5c512b94785f1376a0c03d6cc8efec5fc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "153637e5759fe5730b3dcbf5049b8bb7bfc62a2832d2712c8cd6f176b47f3e91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c3882a5bd1998fdf42c7fafe15fb71c4697aa8889ec867f47218158121cff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac5eb8d3588b7ed16bcc37fdc7d63ee4b569b90cb216588cc67ad78f3a05f2ab"
    sha256 cellar: :any,                 arm64_linux:   "771658363cf23eed3a572ac255d92b9ced55560dc6d55e8447f58ea005b98b52"
    sha256 cellar: :any,                 x86_64_linux:  "6c0df5653cdc88dcbd15281006b440165c373754b2c6e81fc285b05b9a2d1d82"
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