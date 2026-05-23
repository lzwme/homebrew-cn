class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "4aecae9194c2f39a5fddaa6eea2a3727dc7eed8beab4de1b2739609a6fed1d6d"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "722b25444ab490ee72bcbffacdb4241e213563fc8f3ee23f6d18fba1de9b2c53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "722b25444ab490ee72bcbffacdb4241e213563fc8f3ee23f6d18fba1de9b2c53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "722b25444ab490ee72bcbffacdb4241e213563fc8f3ee23f6d18fba1de9b2c53"
    sha256 cellar: :any_skip_relocation, sonoma:        "6771e155e8bf2bebd401872271fb49ad0811ea843330274673aca2e70f5c309b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "867fe201539c71557a9d6beb72c53b52c04ef17898c4b641cd10d49fc06734a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4d26fc4007bc869952ecd34763eacf719dff9483c53f4560fc79e515cb7a906"
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