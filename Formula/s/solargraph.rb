class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.49.0",
      revision: "c8d40adc997efc90eff1892a0e161543a696d358"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6e37a2d76d41c99e94d3c3b57ade7f12f28fc6298ebd5cacca41140d8aee1a3d"
    sha256 cellar: :any,                 arm64_ventura:  "bd1c948b9821b79b5bb097f786010e034978cff71510475b3f66f23b7bfd4e10"
    sha256 cellar: :any,                 arm64_monterey: "4feec3d009fa0278f3911647f2b660607766e240c9d8734e7ea3ea7736870e15"
    sha256 cellar: :any,                 sonoma:         "d835cf734682a3afbbaaaed11fb35192b991faed172a59c2a5e27080fb32cd9b"
    sha256 cellar: :any,                 ventura:        "ce7926241a910fbeb98c92450d4025670e57fcd5054b1b65c60a018404109f51"
    sha256 cellar: :any,                 monterey:       "39206224c7f51bc155c3ca572d83f7d3e47f3236d62cfd9509fd4713aacfc9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "762046eafbc2a0d3480d3b862775d72978171dbd55f96991caffbc4114f68fa0"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  uses_from_macos "xz"

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

    Open3.popen3("#{bin}/solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end