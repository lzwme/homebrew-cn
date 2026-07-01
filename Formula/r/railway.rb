class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.23.3.tar.gz"
  sha256 "0be0adbbf263c141137ec304690b0ebe2e09b56ea20c00ad74e2b56b899c1b36"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc98dc930a7b8f90c7c241ccd87aa56f68338444400b08e9e3c5c42c8e29be96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff34541ca97dab840f1b974775cbcedc10f06c9db8a32691d9fe80e5fcb8c3a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f70f7e5fd0df57828802fee9e7ce1540e0bec9d179e48d7762fc22d55a7f2b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb6c2f085b3153696eb9aeba653ec485e0913b0188acd4a389457f34e6b88635"
    sha256 cellar: :any,                 arm64_linux:   "6fc7bb898fcade6ff657d31d503298842ee42a8a66fa20b96c7d4eb08ed3dd1d"
    sha256 cellar: :any,                 x86_64_linux:  "7a0f47e33084996fd7c7f04f2501b06ecfe51b2e5e8ae1f235172a466fa5b9e2"
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