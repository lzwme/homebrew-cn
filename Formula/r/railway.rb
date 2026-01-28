class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.27.3.tar.gz"
  sha256 "c702ddb45bc02e4f3b2a799648656f7dba99cc7ad57fc89b375b0acff53f13c4"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e625ea1017c4050a737da3c4c2ba3b72a07a2e730d03c47a7418cd10a2bbfec0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c6ae8b622e6f2f7003437cae76f38de1f87e916720053842713d3395ff3c1db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb7aa8475d8e92f6620e790140da6474a752d0f1904024255e321ffe40cbff60"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab046f7ba2229f1af0c81b196d5966cacb2a8a0babc94e216a74dc56f3746282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aef60597bb051bf2e6ad3481e5ccec5a205b03a5d1a7f131a8c3c8d3e04ed668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c80829f0c130a5f3a46e49814d07b8f085375e23784b49f8e8363d9767d51d"
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