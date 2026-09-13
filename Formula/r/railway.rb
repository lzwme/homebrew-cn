class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.54.0.tar.gz"
  sha256 "49714fbc6bd33027ea7c7e9099984e94abd1c13d8128b18a716ba554fb2cc7fa"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "706e37388fd7bd5fe2de5049f34f69affdaf006cf36cddcb48d80f4da172fab9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef5c437a42cc9998d103064b1cfbcd0c11491d354042e06a495098b269863024"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71b89a68b9b6f96d4d8f0b685dbb5eb7fa722a0f17d0963caacf8ace82324992"
    sha256 cellar: :any,                 arm64_linux:       "05177e64aba83005c00a7358cd30e337fb6c13e3a7f6f9d1362202373a426d2b"
    sha256 cellar: :any,                 x86_64_linux:      "b0edbc0b3bda76dee383899094c19ecf4276f4aa36ffffa76daf85b01b955864"
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