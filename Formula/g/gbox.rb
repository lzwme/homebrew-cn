class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.1.5/gbox-v0.1.5.tar.gz"
  sha256 "9889e7914996f901d6e6ec6c80c9dc76ee97fd09c2bb193e5e040901d2ea916e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8d0056d0b79fbccc9f90676056a0bc78e07a17f7307c13082903f5ad6d313c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c6139caf88e5fa6158f6495f8a99d408665e08fdd6122db992b5e741d254bd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f4bf84df4b90cf1f10d4d5f999f5dd76394356e3f91f533cf4a8e4a0bd03bfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b1bb52d6b642fd1772b2fdfc72e9cee576d47e03d90fa6f84b6ef6154dd0268"
    sha256 cellar: :any_skip_relocation, ventura:       "f7542254e4aa3a71982e4596deb5a730232509e4a3c33960884714217cccc5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14acff8b89697938160fff368039d65d6d2dbceb1f121abf36c7565d1999683a"
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