class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.27.2.tar.gz"
  sha256 "4755c7a79e7cf49d5fb2f024231e5ceb55e33aeeb1821a84ac62c1c25fad4cfd"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10568184de7be6f23fad4c0605310506e3ff9f601a56a87ed4120f6568d5840b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f567b8ab9eee5490d0dbc15cce24731d0d9938cb3f31439b3fa89b235ce2baaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea397fd28e1415dbe26e5470c68d2da3a0298ee1809b820dbb74588df1e1a404"
    sha256 cellar: :any_skip_relocation, sonoma:        "aceb83d5f1264b75b92afc362e030679ed60830556a17b5167b65a3b9dca18d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ac1a0e1e4ea1136ddebad374140a9bef97bf62c2210d86cd79f53c0d064d642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a30752b240ea93091d8f2c21024c8e34fb8a2f64683aaafbaf10c7b0b7545e82"
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