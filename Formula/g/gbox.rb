class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://ghfast.top/https://github.com/babelcloud/gbox/releases/download/v0.0.19/gbox-v0.0.19.tar.gz"
  sha256 "41e94e96a756bb4ec81d049080fe15b45d5b3c59785f54965daa364aa7813331"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d51e41d35226cf0d9ef00cce72729598114e8eb7d5a52e5fcd33051bd3134b05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22ed6fba82e288fc6c79e7fa46ae0d88bafe74db49836753b2bc52869fd1f179"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2737330361a010efb1a7557e1c781e91cd78337e8ab9a52414190d6e111e8bd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa31a5cd0c2eae8b9c94d8627bd2f13567d14b9146973af1d2748ac3c15e014"
    sha256 cellar: :any_skip_relocation, ventura:       "f6c1211cc95356191a961c4e9a241eb2e5942c8fad2dcf898820c7cae6914839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cfe0d53c7df446dd566082012c6cd27a5feea2faea58c2e6c448a996741c4fd"
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