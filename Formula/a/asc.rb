class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.48.0.tar.gz"
  sha256 "0f60eeb4f52e30464c7d4b4fdb6003cfe42a2d9b5acb1580e7c91d209fa0dc78"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c1da91e22abc95109bc6e6176b6a628744d9f551a3f06975cbb12788b01f6d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aa0ac1e039cd3d32ea04045c92bbeff18c793c06598984d8e97818d943daacd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc3b0abe9a0d0ac794109a97aecfadf212760871dccd6971f5ea62ecb5a7c623"
    sha256 cellar: :any_skip_relocation, sonoma:        "35ee52528736129eb01a85e6e86db062f0987434858f0246cf0d30f64d1e2fe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f420c2155a2511e270ec1e0081572ada3df3f8c2506ebfd1085753a0d8caa2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b80f854b485c1a72055d706e497ebcec34f24033c7b5d0800a6efe1c89140f0"
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