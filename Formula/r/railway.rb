class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.30.4.tar.gz"
  sha256 "5b685e0c1648766a1266f519a42512a67182ed4d9186cce7663010075d1aa8b9"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a64d1f9dd97f2c34e7babb3615b6fca1c89b0cc4353d58ca8c39b1199cac16ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "475cd7a147ea4247acc3f76f176fbaa06114989f8b72e2d43c08411b6d07683f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07d21d21effdefb07fa4d862cb4ccf6b1c700997f7d750104835a1691640903d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d54e27d21d069a75f77660b9dae829cc52c8f4a3d52bcb5711daa09b03d7277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "427cd7d24fcd7f024e18ee0a827a9c35c7f0c4e9299b5b513453ed2eb8fe7e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25d23d7d2096dde88940487ee54b3710667b66103289f60d749a87fb19220c96"
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