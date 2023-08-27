class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/v2.9.13.tar.gz"
  sha256 "3514d9888b323df716041960bdc2469ae16c08db9545de4324d2405380dccc34"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d33f4e8bb9a027c76bf4089c2f93ecb1d27c5121615cf4b609c65454e3a4736"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2301708655e79e0b06aa73d64b01e281564e77d69b4a124228231ae71ff4054"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2c5915459ac532eea53cd41f42ffaa8bc1f4efe6e5ce724a2e82d99bc253681"
    sha256 cellar: :any_skip_relocation, ventura:        "9b8e11ce69607d658628dcf6ed7d4247fe93d776c1a3bf13bd9f95ea27ca9bc5"
    sha256 cellar: :any_skip_relocation, monterey:       "71f1e352e2e65d507d72a8d559e7ee257b18e20911b843643c2006531cf5a414"
    sha256 cellar: :any_skip_relocation, big_sur:        "81f267818f3e82ab0ce72944dc76f0bbaa1dccdf64164d9398b184c3857132ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b15799665384f89ec7ecc450a32e2277575d4d54585666849e7c8e1dcf943e0b"
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: "{{FQDN}}"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - "IN\tA"
    EOS
    system bin/"nuclei", "-target", "google.com", "-t", "test.yaml", "-config-directory", testpath
  end
end