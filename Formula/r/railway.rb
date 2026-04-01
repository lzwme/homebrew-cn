class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.36.0.tar.gz"
  sha256 "c45eb784c44ae39799b5e45469a388c7de740b5547ab4bc05340cccc6953a082"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69337d467870b99b73589da286802fd4d8227bd13c77e427128309a391c6a8a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d91b91fce21a88f4290bf7d01aea8bb12c94d87fde79c4a4bb6010edff38ed26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17e29a2e12f0546fff5c4cd193c39e640aa7f468bf4c9856fe09b224ca425a2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a2cce46d0727810c5bdd04a15d6489b3982c97d1cf7c89b6c60cf47916ba4e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77d86951a267170302df1d954b70ee1142bc8741ce712e27274f6d1c4b0bb718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566da7cb74adc9d5ccab9530d16c825886a8c081fd17004d296c98509894bb6d"
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