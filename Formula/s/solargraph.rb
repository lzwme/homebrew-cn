class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.55.0",
      revision: "b036fbebb9fc87089ea15c96565443e075a98751"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65aa365a408e2cf95dd1220d0b29b92df6ce7d137882d400eb170c941dc7b57e"
    sha256 cellar: :any,                 arm64_sonoma:  "609854b1f8a48e4e3fa7e9e9072d3ced01149dbd5b9b5775d9874e2a9051119f"
    sha256 cellar: :any,                 arm64_ventura: "acb40bb1fcb31ca6cf8915053967af517b940add8239e3442bb0411714180b77"
    sha256 cellar: :any,                 sonoma:        "a0c669d10cb0dc2a3aa46756be567dca9a390422e8e062d96a1af20d3345e85d"
    sha256 cellar: :any,                 ventura:       "c155aebe765df45f6630aa63bab855b7f0f7651f88dd4bbcb1ccaa434e286970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "119d0b06865a8ed59816d24a357a47c51bd74c796cf2b2ae8073994e119b554b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db46caaa22db1a5909b7059153b30e1c49fd718016c99437d0b5cb4af7bc0f5"
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