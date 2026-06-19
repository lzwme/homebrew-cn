class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.89.0.tar.gz"
  sha256 "c4c0ecd583dfe8142357e31c95f390e19e8a24687bcd0350c801b68da2d03581"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65bdfc5b0f9673faeb79365ae21d641e8683c3931e0f343c5ff014ce8a09f624"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65bdfc5b0f9673faeb79365ae21d641e8683c3931e0f343c5ff014ce8a09f624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65bdfc5b0f9673faeb79365ae21d641e8683c3931e0f343c5ff014ce8a09f624"
    sha256 cellar: :any_skip_relocation, sonoma:        "5393d99dbbfbadc97ed37c4b1ee9db9e4ced41e2c4fc8e114e90f5775fae0a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81e07b57123691bac10a7802989b33a67e1ce85063f411b15b0e8f3a2437936e"
    sha256 cellar: :any,                 x86_64_linux:  "0f69fb8acc73fdafc9f9025a68bfa6d517accb0bcb52e35d59c30fd2623b95ef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end