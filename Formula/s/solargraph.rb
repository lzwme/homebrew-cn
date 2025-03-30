class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.53.3",
      revision: "767a5fceb74935d03f6757711bdf610df3e6fd7a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a99023e720f2e0cfde78a0410936e51a64f9caaba86f8c2fc46e8b6ddc3bec1a"
    sha256 cellar: :any,                 arm64_sonoma:  "137467fcc0c98d464a63251a7c0e7318e19bbbe7aa9b7fa380046ea5e7ea8f58"
    sha256 cellar: :any,                 arm64_ventura: "842edbd4a92b8bfc886bb2993a54b43fddf91c25fff025deacc7c1808ec208bf"
    sha256 cellar: :any,                 sonoma:        "4b166f526b1aea8ea9239b0e12b7eb7402e7af5804c4e5e151a6f5ca9e7429e2"
    sha256 cellar: :any,                 ventura:       "3da2c4e81bf44c29db83add7540bda8fc97a01f7a96a96a803b73db6ef21ca23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dfcdff13b101d7657c850135c5c139e9566efea5b386c22e2c7a7ec4ea9a3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4bf0f06028cff7c010410b653f6298994779a132cca7b2a61f57582c6f94975"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  depends_on "xz"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin#{name}"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
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

    Open3.popen3(bin"solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end