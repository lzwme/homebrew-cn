class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.2/gbox-v0.1.2.tar.gz"
  sha256 "197941698a98c728843037e99350db449c3ee366c31e691ccb5f0af804011c58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "324982144902c9a5d7a64d6cb8c7b1dd5b0d9f20fe68f10ca42d56aec8dcd9b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "588141f835383ed5f38495d902fafc8057f582cd6eb75464a5e4d0235d8a1006"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb4a2c656d0314cfd1ad0311b2d12f4ee0c1a80874c4a5436152e625e86ea701"
    sha256 cellar: :any_skip_relocation, sonoma:        "8624c6f01e54d02b8faaa0bff72c0bbbe7f9e364772371161346a36e282da6ec"
    sha256 cellar: :any_skip_relocation, ventura:       "90d763b020efb6cc9d7ddb9456e11a3165bb7b072b4559c8b6cbbb371239f7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6c84bc06764824fcc6fd68b99f5e1cc8be9cc75419301bd767a31a75c9adb4"
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