class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.14.0.tar.gz"
  sha256 "529215de9ce9913b84b91bc85cd910da52b072d218cb5f6b6f5b080d8e2c2729"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8548a8f78990b9deef33d4a381394a5ee8f09c286327824a24051513ad8f8e2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36539fb1f8a739a4cbd07cda0fb5292a48873b66eddc7126fe79e3bdec825a81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c57d9f364fd8035da4e6788a8ca62054343d817160b3c00a7b9b9824fb81473c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dd6bcbb5f79d1f96cbd19534b769deb1d8c8736dea06dd4d88204433b9cd591"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc1bb9f797a76f388468816e1cac8fbc89d8da4c2ed33cb21d7788192ff1a438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bacd5705c765fa9a9d3834580d33af84d05e55d42aaad0a1df553cfcb393fba"
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