class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "b2bdb5909e2ddde6086e9349d9cb8c02827f37154f4b903e53b328fb92817bc6"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddc38ab5421fc915abcfd8f76991b8d85153c1c5de29f1b4b28f803fb57ab8e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddc38ab5421fc915abcfd8f76991b8d85153c1c5de29f1b4b28f803fb57ab8e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc38ab5421fc915abcfd8f76991b8d85153c1c5de29f1b4b28f803fb57ab8e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7da240c38518d0e8dbb073170ce5def5e5ae8361d991e6d1b3855c6f5a98f7c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85638d52a26c4b964d27ef093a9e1caf382e915cbc81eff3f9c7b804ac0ed6d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0543bc8a1d80ef3c26e5f8e796764ec71b7f85245c4a924b67015d9ced164554"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
    generate_completions_from_executable(bin/"harsh", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end