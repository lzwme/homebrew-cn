class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.35.0.tar.gz"
  sha256 "beef9d2a475e53474c8de4864df79a2f38ac360dae37cb27feca68c076247eaf"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "169d4a31eb53f1752cb8dfa20795bf90d1e177e21bef5c087f52b84d861d057c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c2b87e34af19de0f5f32f27eae2112a04917dbf4ba103868e59278e57de8fdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17261f6722487e2e9fa8ee93258be53a688b84eadf83f13d6739d87788187c76"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dd13ec5b793b922aaebdc052f6e11f2767f2545785811bada79af48fef135a8"
    sha256 cellar: :any,                 arm64_linux:   "c7bb4ab2bb3aeff61bb3b8c7504addc5ba3c3e496a2743c5625174f1f236e16f"
    sha256 cellar: :any,                 x86_64_linux:  "424d9de471c35bc2a595f07e1a6b0b1c8865db2306e55b1e50a20534651db362"
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