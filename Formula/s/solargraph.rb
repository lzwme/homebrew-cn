class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.57.0",
      revision: "9c707a291291ef6b86a030bca80b92b4cc3de7d0"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f384b9bc009d4085aa8f27ed26b5c05a3249c0fae733bf4f900a87009fb16057"
    sha256 cellar: :any,                 arm64_sequoia: "6b901e0277f18854dc018c6d3c32d56483290b31ee6f9d7220e79bad0d7195e0"
    sha256 cellar: :any,                 arm64_sonoma:  "4f46650684a44ec549292a3c0fe72749f7056f931dacf4699af2549adc96b0f2"
    sha256 cellar: :any,                 sonoma:        "a6c9eb070b5c3afef0f59b09cccf87f4230f2d08b1f7c929e96065366d1d1d00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d630c37950e2af45864ee0b359a3bc07b277f994c62af54ed3a89534be8930a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf219188d77ca1766944e9e6c21a1c09a658065cfac077518ef097bcd3a45fa"
  end

  depends_on "ruby"
  depends_on "xz"

  uses_from_macos "zlib"

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