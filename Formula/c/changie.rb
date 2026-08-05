class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://ghfast.top/https://github.com/miniscruff/changie/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "6950c6a793c4e827348ae6e36ab681c361422613ac59819d516be52ccc1abbb7"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db9263a4b2cdd8db83312d84fc823bb0d2fe217719047a60d431e56fa2e0f6f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db9263a4b2cdd8db83312d84fc823bb0d2fe217719047a60d431e56fa2e0f6f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db9263a4b2cdd8db83312d84fc823bb0d2fe217719047a60d431e56fa2e0f6f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "335ab1532bd6fcd25737021dc4d3d70bef602247dad5944209362aa311bbf506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "785635a99efa38601a7f780da6365a660c4b289cf05269a683882dabd47e8d84"
    sha256 cellar: :any,                 x86_64_linux:  "73910251d60512ae063653e6b1cd44b680526bb2f6483cd62aadaf19a027f910"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"changie", shell_parameter_format: :cobra)
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end