class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.4/gbox-v0.1.4.tar.gz"
  sha256 "2cfaacc86d42d68b8fcc3d665fb8cfc24f713f95f34dd2bfa9aaf8b39f624a24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aeb4f89aa32c89efd640f20cf2e279b7c152ab23a9a08ef51c11ced2a501602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bfbcfbc25198113bac51dbe25558c8cf10b558fc6d2f62fe91d7beeed70a93f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "127a91bbfef73a206027cfdd7e4a249b8fa641f9b3e16777bfa0f703b50979fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "62fd55903983db32a928934c377c6d5d0215ffbd57a1bead6fbaebd39de7a82b"
    sha256 cellar: :any_skip_relocation, ventura:       "2066f587845c7e4c37280e154636065f4f8f938833a50a9e3b5636c6b69e3b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8157eb9956fd28b0fb187bf684a92ee53ce5471a0fa38789b59cca50e6c04d0"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "yq"

  uses_from_macos "jq"

  def install
    system "make", "install", "prefix=#{prefix}", "VERSION=#{version}", "COMMIT_ID=#{File.read("COMMIT")}", "BUILD_TIME=#{time.iso8601}"
    generate_completions_from_executable(bin/"gbox", "completion")
  end

  test do
    # Test gbox version
    assert_match version.to_s, shell_output("#{bin}/gbox --version")

    # Test gbox profile management
    add_output = shell_output("#{bin}/gbox profile add -k xxx -n gbox-user -o local")
    assert_match "Profile added successfully", add_output

    current_output = shell_output("#{bin}/gbox profile current")
    assert_match "Profile Name: gbox-user", current_output
    assert_match "Organization Name: local", current_output
    assert_match "API Key: xxx", current_output
  end
end