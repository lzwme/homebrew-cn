class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://ghfast.top/https://github.com/BishopFox/cloudfox/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "f49faffd25a44060a8a58239bc1582d026eceda51a1718e4904d5bf0a77965a6"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed74902a6b0ad21e0ff7bfa52eba8cc8d75f3cb3579a8b7aab03088001491ac1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed74902a6b0ad21e0ff7bfa52eba8cc8d75f3cb3579a8b7aab03088001491ac1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed74902a6b0ad21e0ff7bfa52eba8cc8d75f3cb3579a8b7aab03088001491ac1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9adafa2b68496bcd00308e0e9bdae633d6d2ef2e511be995c055fef98a841e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a20ea1e8c3b9dda31ada82f85112f9bfde6e2dacba7b073213c3db003439598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4047a590db3d10b4f4293f09c96a2e810896f699223d0187a2e2cfe011581e0e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", shell_parameter_format: :cobra)
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end