class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.1.0.tar.gz"
  sha256 "dbb15c2c6e2690241a7e0a8e21cea39468a791ae054c584a40b16a813817f094"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ac9ce2b416872c364bf99504b82cd416e8457a383734d90b1af8d98f60b8e57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5f20ce3891e53493bc08a76ddfdb95ed6b0d530a71133c85831b3ce8439375d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61731e709a7595e2ab2a4bc105b67ebe122808c3dbcdcb478a0791fd3388ce4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d25348659557769577b63ff4f1acfb4e0dff5569b15d6b00ca269cee17501daa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bc5b100c0f14323ba3446aea01c8e21bc684a6a5c56e7d508112fb4120f2cbd"
    sha256 cellar: :any,                 x86_64_linux:  "7fe37a77f80df79de6d4d2b6b4835c76a97f1d48e5c0972c857d25d4b097fb8d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end