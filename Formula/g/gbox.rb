class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.1/gbox-v0.1.1.tar.gz"
  sha256 "53daf286d714e19972ab6135f02c3c946bc078a07b161fae3cafc4df9ce8265e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d4cc59a677e680b543c1d563085846fd5ed545285bf12e9df060c5a376c3650"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dafd3b6b8e7ebd0cc6235f413e06030bc6818454b4b0edd21e57cd3b300edaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd6443c18df51f8064342482d9b5da31063608b7553345925f8caeaafb5da820"
    sha256 cellar: :any_skip_relocation, sonoma:        "991dc12d830af152fc857271acb4e876c55472970f80d16137ba51372da7b2b9"
    sha256 cellar: :any_skip_relocation, ventura:       "c2e015645d6a128e158226786c0985204d8e9b2c867977a588568a7b9ccb991b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a724432b595f9a658130eb74467bf25200c09d3ad675f79ae08ec0d8fe1b9e6b"
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