class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "b2bdb5909e2ddde6086e9349d9cb8c02827f37154f4b903e53b328fb92817bc6"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "348204ec3b79bcecfc973be7c3d0cd383842701a28db5eba2d93cdae321344c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348204ec3b79bcecfc973be7c3d0cd383842701a28db5eba2d93cdae321344c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "348204ec3b79bcecfc973be7c3d0cd383842701a28db5eba2d93cdae321344c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95d4d4891176bad062e3fbee076160dffb5b3186a4bae411f13405d502e1c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "730143b1a6c755437fa9301cd2947cc4f44031e61fecd04c91b5ac757f11415b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "269eba6f7b315fc448263299eb1abd3e5484806367b6536e12450243d43b8d21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end