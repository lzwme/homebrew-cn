class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.0/gbox-v0.1.0.tar.gz"
  sha256 "33d48ffeaccce542a465ad778ed6162474498d7504b1a8d0dcdb8d6f7e7e5a7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17a4cc91e41e26ee74bc4cf2bfab30c0c3a6183635d6eb9816a3eda9a665f86a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fefd0fae450e872188f90aa9e86cf3abf2fd5bb80d52a840378b319e86c3a83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88299a4c6886a1593f96e6024121ac515724800302ab10681b972b7110d1d80e"
    sha256 cellar: :any_skip_relocation, sonoma:        "961b5d2892d5d343fc364f308a525a335943ea33ef343c218a7a781374896217"
    sha256 cellar: :any_skip_relocation, ventura:       "0a3f57a672220b50ab69ac277e8fd33ff85380fb7ccb0819f5fa03d4fe5985d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60a0a45e8d6bf91561ce6281b012e876c835b626d9794632b5d268d2d6c4f640"
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