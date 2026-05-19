class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.59.1",
      revision: "56e71bb3eca9727fe1b086e1eb2f7eeb2009049d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1a05afcc44b2f88ccdd47d54368b03e08e86bcfc35924ede456f21ffe5b05d1"
    sha256 cellar: :any,                 arm64_sequoia: "487d2cdb209548a568fd1898e9fe5c3e026e1296191d660521fe1ffdcacf1646"
    sha256 cellar: :any,                 arm64_sonoma:  "116c18c41fb3c8e59cd32243bd0e2422c49d242cde7119ffbf0005b74c248827"
    sha256 cellar: :any,                 sonoma:        "c629c02faba574d880c89f5d3e547542d08cc9b4e263f1b4a34b2a5030dd75a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a543218d1828b6ee0b332a1ee507b753c8d1970d8c5baf219cbdbd8b5ac9e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "895b5f7547690c09eee348c5b5dc9cb6c8c89838d713e104a5545de61ee25357"
  end

  depends_on "ruby"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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