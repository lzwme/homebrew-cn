class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.0.20/gbox-v0.0.20.tar.gz"
  sha256 "962dcea209b87e77f89d6e3a555600cf5d3d187bfcfd4e3a040c69016c80f0ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6091789411821fb23b9c678bbf19c2a2a56904c7d759448880e93a32d9d74fa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6afd5ea49c05c055d3754e7780818ed655080ee90af264cfdcd64b70582f552e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efdca29dcb388a5332528a9e119d3e60ca351b7d8faa316f7a03ed5803b2a1c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "167229188509bc2c4ac5f4d5162f0cbe56198ae0d13031108656574442dd352f"
    sha256 cellar: :any_skip_relocation, ventura:       "3463cf43f2ed0de10defd23e1df81dcaba890d988c6f613865ee6fc2107523d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7b4f5c993be3964612649e86679152c9784ab7005bffc2c2eb8cf1e55eb8db0"
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