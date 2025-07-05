class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.56.0",
      revision: "ebfbdbc13d45b4cf7a5f11271bfaf704a40a8c46"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7109365ddafef00f3b440d62a20fbe0c7301bc891ad22617ca4a05bd580cc11"
    sha256 cellar: :any,                 arm64_sonoma:  "fcac504c952372cd4eaf63c3ba91666e93f9bdcbb0e712e9a60b91188a968441"
    sha256 cellar: :any,                 arm64_ventura: "ebc634dc0f8220c7ee90ec1fcf21b6f3039cf99233a75d08e0b8a62717ebf00a"
    sha256 cellar: :any,                 sonoma:        "02cad3476178f4aca8c79f69b4534e5a93885d0dc96191cf1ad612d93a683b60"
    sha256 cellar: :any,                 ventura:       "180ba3ad93223b80e6cc5dc9ad16dc22b8c1ee4d1d3a9875c08570f05cec6572"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c326c60d65a367e9ad02402f45fde29c8e30eeec40e64efdfcb342926fb4933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c3b8454189ffe976e544371385ec85116585b516ebcb454d4e8d2b92835ac3"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  depends_on "xz"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end