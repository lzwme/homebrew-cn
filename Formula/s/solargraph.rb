class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.54.1",
      revision: "ff7745c3a3168025a62a1f8f1705c61174d8c93a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "131ad522f4698c699de572e8d661960ae01dce904ce929988b497cef7d84b540"
    sha256 cellar: :any,                 arm64_sonoma:  "73406f5c7c41b638e5d9aba58a9c8daf5431ef87b8a08a30df116dabda025dbb"
    sha256 cellar: :any,                 arm64_ventura: "76b2f34f1a579f08f44dac9b8c3f0ae3687c30932d26da8f09e26006f2d9b647"
    sha256 cellar: :any,                 sonoma:        "516e9a7abaae41f0a8fec20a8188e0e14f24416d9ed360fe85e5a85ad93f92f2"
    sha256 cellar: :any,                 ventura:       "4a180b06956b1d3b0daf6f3d077b652b66f5df2b4c949d9cac51f7e960d5b53c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a53a747a677af53312eb49c8c412c8ce2c9a50670ea2134af2161aeb31d1a56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e6533bb3a6449445e4b66f4304deaac2d07451564883d7c8586b91df535a25d"
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